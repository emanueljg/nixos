{ config, pkgs, ... }: with pkgs; let
  coverDaemon = writeShellApplication {
    name = "coverDaemon";
    runtimeInputs = [
      ueberzug
      inotify-tools
    ];
    text = ''
      source "`ueberzug library`"
      COVER="/tmp/album_cover.png"

      function add_cover {
        ImageLayer::add [identifier]="img" [x]="2" [y]="1" [path]="$COVER"
      }

      ImageLayer 0< <(
      if [ ! -f "$COVER" ]; then
        cp "$HOME/.ncmpcpp/default_cover.png" "$COVER"
      fi
      #rerender image when changed
      while inotifywait -q -q -e close_write "$COVER"; do
        add_cover
      done
      )
    '';
  };

  coverSwitcher = writeShellApplication {
    name = "coverSwitcher";    
    runtimeInputs = [ ffmpeg mpc ];
    text = ''        
      COVER="/tmp/album_cover.png"
      EMB_COVER="/tmp/album_cover_embedded.png"
      COVER_SIZE="400"

      #path to current song
      file="${config.my.services.mpd.musicDirectory}/$(mpc --format %file% current)"
      album="$\{file%/*}"
      #search for cover image
      #use embedded image if present, otherwise take it from the current folder
      err=$(ffmpeg -loglevel 16 -y -i "$file" -an -vcodec copy $EMB_COVER 2>&1)
      if [ "$err" != "" ]; then
        art=$(find "$album"  -maxdepth 1 | grep -m 1 ".*\.\(jpg\|png\|gif\|bmp\)")
      else
        art=$EMB_COVER
      fi
      if [ "$art" = "" ]; then
        art="$HOME/.ncmpcpp/default_cover.png"
      fi
      #copy and resize image to destination
      ffmpeg -loglevel 0 -y -i "$art" -vf "scale=$COVER_SIZE:-1" "$COVER"
    '';
  };

  tsession = writeText "tsession" ''
    neww
    set -g status off

    #image pane; run cover script, disable text output and remove prompt
    send-keys "stty -echo" C-m
    send-keys "tput civis -- invisible" C-m
    send-keys "export PS1=\'\'" C-m
    send-keys "clear" C-m
    send-keys "${coverDaemon}/bin/coverDaemon " C-m

    #catalog pane; run instance of ncmpcpp
    split-window -v
    select-pane -t 1
    send-keys "ncmpcpp --config='~/.ncmpcpp/catalog.conf'" C-m
    send-keys 1

    #visualizer pane; run instance of ncmpcpp in visualizer mode
    select-pane -t 0
    split-window -h
    send-keys "ncmpcpp --config='~/.ncmpcpp/visualizer.conf'" C-m
    send-keys 8
    send-keys u

    #resize image and visualizer pane to fit image
    resize-pane -t 0 -x 49 -y 23
    resize-pane -t 1 -y 23

    #hook for keeping the image pane size constant
    set-hook client-resized 'resize-pane -t 0 -x 49 -y 23'

    #focus on catalog pane
    select-pane -t 2
  '';
in { 

  my.programs.zsh.initExtra = let tmuxPath = "${pkgs}/bin/tmux"; in ''
    alias music='${tmuxPath} new-session -s $$ "${tmuxPath} source-file ${tsession}"'
    _trap_exit() { ${tmuxPath} kill-session -t $$; }
  '';

}

