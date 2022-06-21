{ config, lib, ... }:

let
  inherit (import ../../constants.nix)
    COLORS
  ;
in

{
  imports = [
    ../../hm.nix
  ];

  my.programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
    };

    # manually load the Clrs theme
    extraConfig = ''
      # vim:ft=kitty

      ## name: Doom One Light
      ## author: Henrik Lissner <https://github.com/hlissner>
      ## license: MIT
      ## blurb: Doom Emacs flagship theme based on atom One Light

      # The basic colors
      foreground                      #383a42
      background                      #fafafa
      selection_foreground            #383a42
      selection_background            #dfdfdf

      # Cursor colors
      cursor                          #383a42
      cursor_text_color               #fafafa

      # kitty window border colors
      active_border_color     #0184bc
      inactive_border_color   #c6c7c7

      # Tab bar colors
      active_tab_foreground   #fafafa
      active_tab_background   #383a42
      inactive_tab_foreground #f0f0f0
      inactive_tab_background #c6c7c7

      # The basic 16 colors
      # black
      color0 #383a42
      color8 #c6c7c7

      # red
      color1 #e45649
      color9 #e45649

      # green
      color2  #50a14f
      color10 #50a14f

      # yellow
      color3  #986801
      color11 #986801

      # blue
      color4  #4078f2
      color12 #4078f2

      # magenta
      color5  #a626a4
      color13 #b751b6

      # cyan
      color6  #005478
      color14 #0184bc

      # white
      color7  #f0f0f0
      color15 #383a42
    '';
#    settings = {
#      background = COLORS.dark-blue;
#      foreground = COLORS.white;
#    };
    
  };
}
