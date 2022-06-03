{ config, lib, pkgs, ... }:

let
  inherit (lib.lists)
    range
  ;

  inherit (import ../../../helpers.nix { inherit lib; }) 
    doRecursiveUpdates
    genDefault
  ;

  inherit (import ./helpers.nix { inherit config; inherit lib; })
    genPolybarStartup
    genWorkspaceOutputs
    genColors
  ;

  inherit (import ../../constants.nix)
    BAR-HEIGHT
    GAP
    COLORS
  ;
in

{
  imports = [
    ../../hm.nix
    ../polybar/polybar.nix
  ];

  my.xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
      config = rec {
        startup = [
          {
            command = "feh --bg-fill ~/pape";
            always = true;
            notification = false;
          }
          {
            command = genPolybarStartup; 
            always = true;
            notification = false;
          }
        ];

        workspaceOutputAssign = genWorkspaceOutputs { 
          "DVI-I-2-2" = range 1 5;
          "DVI-I-1-1" = range 6 10;
        };
        
        gaps = 
          { "bottom" = GAP + BAR-HEIGHT + GAP; "inner" = GAP + GAP; }
        ;

        window.border = GAP / 2;

                           # focused border, focused indication, unfocused border
        colors = genColors COLORS.dark-blue COLORS.light-blue COLORS.black;
        # see how the rest of the colors are inferred in ./helpers.nix

        bars = [ ];
        terminal = "kitty";
        modifier = "Mod4";
        keybindings = lib.mkOptionDefault {
            "${modifier}+q" = "split toggle";

            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+BackSpace" = "exec qutebrowser";

            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";

            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";

            "${modifier}+Up" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "${modifier}+Down" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        };
      };
    };
}
