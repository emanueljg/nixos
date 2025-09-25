{
  config,
  pkgs,
  lib,
  ...
}:
{
  local.programs.waybar = {
    style =
      let
        inherit (config.local.themes."Everforest Dark Medium") fg bg;
      in
      ''
        * {
            font-family: "JetBrainsMono Nerd Font";
            font-size: 18px;
        }

        window#waybar {
          padding: 10px;
          margin: 10px;
          color: ${fg.fg};
          background-color: ${bg.bg0};
          transition-property: none;
        }

        #workspaces button {
            border-radius: 0;
            border: none;
            color: ${fg.statusline1}
        }

        #workspaces button.visible {
            background-color: ${bg.bg_green};
        }
          
        #workspaces button.active {
            color: ${bg.bg0};
            background-color: ${fg.statusline1};
        }

        #network {
            margin-right: 40px;
        }

        #battery {
            margin-left: 40px;
            margin-right: 20px;
        }

        #pulseaudio-slider {
            margin-right: 40px;
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
            background-color: ${fg.green};
            box-shadow: none;
            border: none;
            border-radius: 0;
            min-height: 20px;
        }
        #pulseaudio-slider trough {
            margin: 0;
            min-height: 20px;
            background-color: ${bg.bg3};
            box-shadow: none;
            border: none;
            border-radius: 0;
        }
        #pulseaudio-slider highlight {
            margin: 0;
            min-height: 20px;
            background-color: ${fg.statusline1};
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
          audio = "pulseaudio";
          audiodesc = "pulseaudio";
          audioSlider = "pulseaudio/slider";
          network = "network";
          audioSymbol = "custom/audio_symbol";
        };
        margin = 20;
        # margin = config.wayland.windowManager.hyprland.settings.general.gaps_out;
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
          modules-center = [ mods.clock ];
          modules-right = [
            mods.network
            mods.audio
            mods.battery
          ];

          ${mods.workspaces} = {
            disable-scroll = true;
            persistent-workspaces = {
              "DP-2" = [
                1
                2
                3
                4
              ];
              "DP-1" = [
                5
                6
                7
                8
              ];
              "eDP-1" = [ 9 ];
              "HDMI-A-1" = [ 10 ];
            };
          };

          ${mods.window} = {
            seperate-outputs = true;
          };

          ${mods.clock} = {
            format = "{:L%H:%M | %A, %d %b | week %g}";
            locale = "sv_SE.UTF-8";
          };

          ${mods.network} = {
            interval = 2;
            format-wifi = "{icon}  | {essid}";
            tooltip-format-wifi = "{signalStrength}% {frequency}GHz {bandwidthDownBytes} / {bandwidthUpBytes} @ {ipaddr}";
            format-ethernet = "󰈁 | ethernet";
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤨"
            ];
          };

          ${mods.audio} = {
            format = "{icon}  | {volume}%";
            format-bluetooth = "{icon}  | {volume}% {desc}";
            format-icons = {
              "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";

              # JBL Charge 5
              "bluez_output.D8_37_3B_79_44_76.1" = "󰗜";

              # Major V
              "bluez_output.00_25_D1_4A_99_49.1" = "";
            };

            on-click = "${lib.getExe pkgs.playerctl} play-pause";
            on-click-right = lib.getExe pkgs.pavucontrol;
          };

          ${mods.audioSlider} = { };

          ${mods.battery} = {
            interval = 5;
            states = {
              critical = 20;
              low = 40;
              medium = 60;
              high = 80;
              full = 100;
            };
            format-discharging = "{icon}  | {capacity}%";
            format-charging = "{icon} 󱐋 | {capacity}%";
            format-full = "{icon} 󱐋 | {capacity}%";
            format-time = "{H}:{m}";
            format-icons = {
              critical = "";
              low = "";
              medium = "";
              high = "";
              full = "";
            };
          };
        };
      };
  };
}
