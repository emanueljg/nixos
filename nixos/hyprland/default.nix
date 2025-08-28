{
  config,
  packages,
  pkgs,
  lib,
  self,
  ...
}:
{

  imports = [
    ./substituters.nix
    ./env-vars.nix
    ./monitors.nix
  ];

  local.programs.hyprland = {
    enable = true;
    package = packages.hyprland;
    plugins = [ packages.hy3 ];
    settings = {
      "$menu" = "wofi --show run";
      "$terminal" = "kitty";
      "$browser" = "qutebrowser";
      "$screenlock" = "swaylock";
      "$screenshot" = lib.getExe (
        pkgs.writeShellApplication {
          name = "grim-slurp-screenshot";
          runtimeInputs = [
            pkgs.grim
            pkgs.slurp
          ];
          text = ''
            dir="/home/ejg/shots"
            grim -g "$(slurp)" "$dir/$(date -u '+%Y-%m-%dT%H-%M-%S').png"
          '';
        }
      );
      "$mod" = "ALT";

      env = [
        "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
      ];

      general = {
        layout = "hy3";
        allow_tearing = true;
      };

      debug = {
        disable_logs = false;
        # https://github.com/ValveSoftware/gamescope/issues/1825#issuecomment-2831929362
        full_cm_proto = true;
      };

      input = {
        kb_layout = "us";
        kb_options = "caps:swapescape";
        kb_variant = "altgr-intl";
        touchpad = {
          disable_while_typing = false;
        };
      };

      cursor = {
        no_hardware_cursors = true;
      };

      workspace = [
        "1,monitor:DP-2"
        "2,monitor:DP-2"
        "3,monitor:DP-2"
        "4,monitor:DP-2"

        "5,monitor:DP-1"
        "6,monitor:DP-1"
        "7,monitor:DP-1"
        "8,monitor:DP-1"

        "9,monitor:eDP-1"

        "10,monitor:HDMI-A-1"
      ];
      misc = {
        force_default_wallpaper = 0;
      };

      bindm = [
        "$mod, mouse:272, movewindow"
      ];
      bind =
        let
          workspaces = map builtins.toString (lib.range 1 10);
          wsBind = ws: if ws == "10" then "0" else ws;
          goto = map (ws: "$mod, ${wsBind ws}, workspace, ${ws}") workspaces;
          move = map (ws: "$mod SHIFT, ${wsBind ws}, movetoworkspace, ${ws}") workspaces;
        in
        goto
        ++ move
        ++ [
          "$mod, f, fullscreen, 0" # entire screen

          # focus
          "$mod, h, hy3:movefocus, l"
          "$mod, l, hy3:movefocus, r"
          "$mod, k, hy3:movefocus, u"
          "$mod, j, hy3:movefocus, d"

          # move window
          "$mod SHIFT, h, hy3:movewindow, l"
          "$mod SHIFT, l, hy3:movewindow, r"
          "$mod SHIFT, k, hy3:movewindow, u"
          "$mod SHIFT, j, hy3:movewindow, d"

          # resize window
          "$mod CTRL, right, resizeactive, 10 0"
          "$mod CTRL, left, resizeactive, -10 0"
          "$mod CTRL, up, resizeactive, 0 -10"
          "$mod CTRL, down, resizeactive, 0 10"

          # vert/hor toggle
          "$mod, v, hy3:makegroup, opposite"

          "$mod SHIFT, f, togglefloating" # bars&gaps visible

          "$mod, Return, exec, $terminal"
          "$mod, BackSpace, exec, $browser"
          "$mod SHIFT, aring, exec, $screenlock"
          "$mod, d, exec, $menu"
          "$mod SHIFT, Q, killactive"
          "$mod, Print, exec, $screenshot"
        ];
    };
  };
}
