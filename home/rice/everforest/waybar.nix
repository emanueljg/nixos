{ config, ... }: {
  programs.waybar = {
    style =
      let
        theme = import ./theme.nix;
      in
      ''
        * {
            font-family: "JetBrains Mono Nerd Font";
            font-size: 18px;
        }

        window#waybar {
          padding: 10px;
          margin: 10px;
          background-color: ${theme.bg.bg0};
          transition-property: none;
        }

        #workspaces button {
            border-radius: 0;
            border: none;
        }

        #workspaces button.visible {
            background-color: ${theme.bg.bg3};
        }
          
        #workspaces button.active {
            color: ${theme.bg.bg0};
            background-color: ${theme.fg.statusline1};
        }

        #pulseaudio-slider {
            min-width: 100px;
            padding-top: 0;
            padding-bottom: 0;
        }
        #pulseaudio-slider slider {
            opacity: 0;
            min-height: 0px;
            min-width: 0px;
            margin: 0;
            background-image: none;
            border: none;
            background-color: ${theme.fg.green};
            box-shadow: none;
            border: none;
            border-radius: 0;
            min-height: 20px;
        }
        #pulseaudio-slider trough {
            margin: 0;
            min-height: 20px;
            background-color: ${theme.bg.bg3};
            box-shadow: none;
            border: none;
            border-radius: 0;
        }
        #pulseaudio-slider highlight {
            margin: 0;
            min-height: 20px;
            background-color: ${theme.fg.statusline1};
            box-shadow: none;
            border: none;
            border-radius: 0;
        }
      '';
    settings =
      let
        mods = {
          workspaces = "hyprland/workspaces";
          window = "hyprland/window";
          battery = "battery";
          clock = "clock";
          audio = "pulseaudio/slider";
        };
        margin = config.wayland.windowManager.hyprland.settings.general.gaps_out;
      in
      {
        mainBar = {
          layer = "bottom";
          position = "bottom";
          height = 30;
          output = [
            "DP-2"
            "HDMI-A-1"
            "DP-1"
            "eDP-1"
          ];
          margin-top = 0;
          margin-left = margin;
          margin-bottom = margin;
          margin-right = margin;
          modules-left = [ mods.workspaces ];
          modules-center = [ mods.window "custom/hello-from-waybar" mods.clock ];
          modules-right = [ mods.audio mods.battery ];

          ${mods.workspaces} = {
            disable-scroll = true;
            persistent-workspaces = {
              "DP-2" = [ 1 2 3 4 ];
              "HDMI-A-1" = [ 5 6 ];
              "DP-1" = [ 7 8 ];
              "eDP-1" = [ 9 ];
            };
          };

          ${mods.window} = {
            seperate-outputs = true;
          };

          ${mods.clock} = { };

          ${mods.audio} = { };

          ${mods.battery} = {
            states = {
              A = 100;
              B = 80;
              C = 60;
              D = 40;
              E = 20;
              F = 5;
            };
            format = "{icon}";
            format-icons = {
              A = "[>>>>>]";
              B = "[>>>>.]";
              C = "[>>>..]";
              D = "[>>...]";
              E = "[>....]";
              F = "[!!!!!]";
            };
          };

          "custom/hello-from-waybar" = {
            format = " * ";
            # max-length = 40;
            # interval = "once";
            # exec = pkgs.writeShellScript "hello-from-waybar" ''
            #   echo "from within waybar"
            # '';
          };
        };
      };
  };
}
