{ config, ... }:

{
  my.xdg.configFile."sxhkd/sxhkdrc".onChange = "pkill -USR1 -x sxhkd"; 

  my.services.sxhkd = {
    enable = true;

    keybindings = {

      #
      # GENERAL
      #

      # spawning
      "super + Return" = "st";
      "super + BackSpace" = "qutebrowser";
      "super + @space" = "dmenu_run";  # change this?

      # volume control
      "super + Up" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "super + Down" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";

      # 
      # BSPWM
      #

      # quit/restart
      "super + alt + {q,r}" = "bspc {quit,wm -r}";
      
      # close window
      "super + q" = "bspc node -c";

      # toggle fullscreen
      # wait, why do we need this?
      #"super + m" = "bspc desktop -l next";

      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

      # parent jump?
      "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";

      # set tiled, floating, fullscreen
      "super + {t, s, f}" = "bspc node -t {tiled,floating,fullscreen}";

      # set the node flags
      "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";


      # focus the next/previous desktop in the current monitor
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";

      # focus the last node/desktop
      "super + {grave,Tab}" = "bspc {node,desktop} -f last";

      # focus or send to the given desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

      # preselect the direction
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";

      # preselect the ratio
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";

      # cancel the preselection for the focused node
      "super + ctrl + space" = "bspc node -p cancel";

      # cancel the preselection for the focused desktop
      "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";

      # expand a window by moving one of its side outward
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

      # contract a window by moving one of its side inward
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
    };
  };
}
