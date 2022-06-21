{ config, pkgs, lib, ... }:

let
  inherit (lib.attrsets) 
    genAttrs
    recursiveUpdate
  ;

  inherit (import ../../../helpers.nix { inherit lib; }) 
    doRecursiveUpdates
  ;

  inherit (import ./helpers.nix { inherit config; inherit lib; }) 
    makeAbsoluteLeft
    makeAbsoluteRight
    makeRightOf
    makeLeftOf
    applyToEachMonitor
  ;

  inherit (import ../../constants.nix)
    BAR-HEIGHT
    COLORS
  ;
in

{
  imports = [
   ../../hm.nix
  ];

  my.services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      githubSupport = true;
      pulseSupport = true;
    };
    script = "";
    settings =
      let 
        bar-defaults = {
          bottom = true;
          background = COLORS.dark-blue;
          foreground = COLORS.white;
          override-redirect = true;
          wm-restack = "i3";
          height = BAR-HEIGHT;
          offset.y = 20;
          radius = 0;
#          font = [ "Vegur:pixelsize=16:weight=bold;3" ];
          font = [ "JetBrains Mono:pixelsize=16:weight=bold;3" ];
        };

        module-defaults = {
          format = {
            background = COLORS.dark-blue;
            padding = 1;
          };
        };
      in
        doRecursiveUpdates bar-defaults (applyToEachMonitor rec {
          workspaces = makeAbsoluteLeft {
            width = 180;
            modules-left = "i3";
          };

          time = makeAbsoluteRight {
            width = 84;
            modules-center = "time";
          }; 

          date = makeLeftOf time {
            locale = config.i18n.extraLocaleSettings.LC_TIME;
            width = 216;
            modules-center = "date";
          }; 

          battery = makeLeftOf date {
            width = 135;
            modules-center = "battery";
            font = bar-defaults.font ++ [ "Material Design Icons:size=18:style=Regular;3" ];
          };

          pulseaudio = makeLeftOf battery {
            width = 135;
            modules-center = "pulseaudio";
            font = bar-defaults.font ++ [ "Material Design Icons:size=18:style=Regular;3" ];
          };
          
          network = makeLeftOf pulseaudio {
            width = 40;
            modules-center = "network";
            font = bar-defaults.font ++ [ "Material Design Icons:size=18:style=Regular;3" ];
          };



        })

        //

        doRecursiveUpdates module-defaults { 
          "module/i3" = 
            let
              labels = genAttrs 
                [ "label-focused" "label-unfocused" "label-visible" ] 
                (name: { text = "%name%"; padding = 1; background = COLORS.dark-blue; });
            in 
              recursiveUpdate labels {
                format.padding = 0;
                type = "internal/i3";
                pin-workspaces = true;
                show-urgent = true;
                strip-wsnumbers = true;
                index-sort = true;
                enable-click = false;
                enable-scroll = false;
                wrapping-scroll = false;
                reverse-scroll = false;
                label-focused.background = COLORS.light-blue;
              };
          "module/time" = {
            type = "internal/date";
            internal = 5;
            time = "%H:%M";
            label = "%time%";
          };
          "module/date" = {
            type = "internal/date";
            internal = 5;
            date = "%Y-%m-%d | %a"; 
            label = "%date%";
          };
          "module/xwindow" = {
            type = "internal/xwindow";
          };
          "module/battery" = {
            type = "internal/battery";
            battery = "BAT0";
            adapter = "AC";
            ramp-capacity = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            format = {
              discharging.text = "<ramp-capacity>󱐥 <label-discharging>";
              charging.text = "<ramp-capacity>󰚥 <label-charging>";
              full.text = "<ramp-capacity>󰸞 <label-full>";
            };
            label.text = "%percentage%%";
            low-at = 10; 
          };

          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            format-volume = "<ramp-volume> <label-volume>";
            ramp-volume = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            label-muted = "󰖁";
          };

          "module/network" = {
            type = "internal/network";
            interface = "wlan0";
            ramp-signal = [
              "󰣾"
              "󰣴"
              "󰣶"
              "󰣸"
              "󰣺"
            ];
            format = {
              connected.text = "<ramp-signal>";
              disconnected.text = "󰣽";
              packetloss.text = "󰣻";
            };
          };
        };
    };
}

