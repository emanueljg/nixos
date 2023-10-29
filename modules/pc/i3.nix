{ lib, ... }:

{
  services.xserver.displayManager = {

    lightdm.greeter.enable = false;

    session = [{
        manage = "window";
        name = "fake";
        start = "";
    }];

    defaultSession = "none+fake";

  };



  my.xsession.enable = true;
  my.xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      startup = [
        {
          command = "autorandr -l default";
          always = true;
          notification = false;
        }
      ];
      terminal = "kitty";
      modifier = "Mod1";
      keybindings = lib.mkOptionDefault {
        "${modifier}+BackSpace" = "exec qutebrowser";

        "${modifier}+v" = "split toggle";
        "${modifier}+c" = "focus child";

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
      bars = [
        ({
          fonts = {
            names = [ "pango" ];
            style = "monospace";
            size = 19.0;
          };
        })
      ];
      floating.criteria = [ { title = "YubiKey Onboarding"; } ];
    };
    extraConfig = ''font pango:monospace 16'';
  };
}
