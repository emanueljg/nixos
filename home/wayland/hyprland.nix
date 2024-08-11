{ config, packages, pkgs, lib, self, ... }: {

  wayland.windowManager.hyprland =
    {
      enable = true;
      package = packages.hyprland;
      xwayland.enable = true;
      plugins = [ packages.hy3 ];
      settings = {
        "$menu" = "${lib.getExe config.programs.wofi.package} --show run";
        "$terminal" = lib.getExe config.programs.kitty.package;
        "$browser" = lib.getExe config.programs.qutebrowser.package;
        "$screenlock" = lib.getExe config.programs.swaylock.package;
        "$screenshot" = lib.getExe (pkgs.writeShellApplication {
          name = "grim-slurp-screenshot";
          runtimeInputs = [ pkgs.grim pkgs.slurp ];
          text = ''
            dir="${config.home.homeDirectory}/shots"
            grim -g "$(slurp)" "$dir/$(date -u '+%Y-%m-%dT%H-%M-%S').png"
          '';
        });
        "$mod" = "ALT";

        general = {
          layout = "hy3";
          allow_tearing = false;
        };

        input = {
          kb_layout = "us";
          kb_options = "caps:swapescape";
          kb_variant = "altgr-intl";
        };

        monitor = [
          # computer mon
          "eDP-1,preferred,auto,1"
          # left screen
          "DP-1,preferred,auto,1,transform,3"
          # main screen
          "DP-2,preferred,auto,1"
          # right screen
          "HDMI-A-1,preferred,auto,1,transform,1"
        ];
        workspace = [
          "1,monitor:DP-2"
          "2,monitor:DP-2"
          "3,monitor:DP-2"
          "4,monitor:DP-2"

          "5,monitor:HDMI-A-1"
          "6,monitor:HDMI-A-1"

          "7,monitor:DP-1"
          "8,monitor:DP-1"

          "9,monitor:eDP-1"
        ];
        misc = {
          force_default_wallpaper = 0;
        };

        bind =
          let
            window =
              let
                fullscreen = [
                  "$mod, f, fullscreen, 0" # bars&gaps visible
                  "$mod SHIFT, f, fullscreen, 1" # entire screen
                ];
                goto = [
                  "$mod, h, hy3:movefocus, l"
                  "$mod, l, hy3:movefocus, r"
                  "$mod, k, hy3:movefocus, u"
                  "$mod, j, hy3:movefocus, d"
                ];

                move = [
                  "$mod SHIFT, h, hy3:movewindow, l"
                  "$mod SHIFT, l, hy3:movewindow, r"
                  "$mod SHIFT, k, hy3:movewindow, u"
                  "$mod SHIFT, j, hy3:movewindow, d"
                ];
                bind = [
                  "$mod, v, hy3:makegroup, v"
                  "$mod, b, hy3:makegroup, h"
                ];
              in
              fullscreen ++ goto ++ move ++ bind;

            workspace =
              let
                workspaces = builtins.map builtins.toString (lib.range 1 9);
                goto = builtins.map (ws: "$mod, ${ws}, workspace, ${ws}") workspaces;
                move = builtins.map (ws: "$mod SHIFT, ${ws}, movetoworkspace, ${ws}") workspaces;
              in
              goto ++ move;

            exec = [
              "$mod, Return, exec, $terminal"
              "$mod, BackSpace, exec, $browser"
              "$mod SHIFT, aring, exec, $screenlock"
              "$mod, d, exec, $menu"
              "$mod SHIFT, Q, killactive"
              "$mod, Print, exec, $screenshot"
            ];
          in
          window ++ workspace ++ exec;
      };
    };

  home.packages = with pkgs; [
    wl-clipboard
  ];

}
