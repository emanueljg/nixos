{ config, hyprland, hy3, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    plugins = [ hy3.packages.${pkgs.system}.hy3 ];
    settings = {
      "$menu" = "${lib.getExe config.programs.wofi.package} --show run";
      "$terminal" = lib.getExe config.programs.kitty.package;
      "$browser" = lib.getExe config.programs.qutebrowser.package;
      "$screenlock" = lib.getExe config.programs.swaylock.package;
      "$mod" = "ALT";

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "hy3";

        allow_tearing = false;
      };

      plugins.hy3.tabs = {
        rounding = 0;
        render_text = false;
      };

      input = {
        kb_layout = "se";
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          # "windows, 1, 7, myBezier"
          # "windowsOut, 1, 7, default, popin 80%"
          # "border, 1, 10, default"
          # "borderangle, 1, 8, default"
          # "fade, 1, 7, default"
          # "workspaces, 1, 6, default"
        ];
      };
      decoration = {
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      monitor = [
        "eDP-1,preferred,auto,1"
        "HDMI-A-1,preferred,auto,1"
        # "DVI-I-2-2,preferred,auto,1"
        # "DVI-I-1-1,preferred,auto,1"
        # "DP-2,preferred,auto,1"
      ];
      workspace = [

        "1,monitor:DP-4"
        "2,monitor:DP-4"
        "3,monitor:DP-4"
        "4,monitor:DP-4"
        "5,monitor:DP-5"
        "6,monitor:DP-5"
        "7,monitor:DP-5"
        "8,monitor:DP-5"
        "9,monitor:eDP-1"
        "10,monitor:eDP-1"
      ];
      misc.force_default_wallpaper = 0;

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
              workspaces = builtins.map builtins.toString (lib.range 1 10);
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
          ];


        in
        window ++ workspace ++ exec;
    };
    extraConfig =
      let
        mkCommand =
          { package
          , options
          , arg ? null
          }:
          builtins.concatStringsSep " " ([
            (lib.getExe package)
            (pkgs.lib.concatMapStringsSep
              " "
              (str: ''"${str}"'')
              (lib.cli.toGNUCommandLine { } options)
            )
          ] ++ (lib.optional (arg != null) ''${arg}''));

        defaultOpts = {
          output-folder = "${config.home.homeDirectory}/shots";
          filename = "$(date -u '+%Y-%m-%dT%H-%M-%S').png";
        };

        mkModeInvoc = mode: mkCommand {
          package = pkgs.hyprshot;
          options = defaultOpts // { inherit mode; };
        };
      in
      ''
        bind = $mod, Print, submap, screenshot

        submap = screenshot

        bind = , o, execr, ${mkModeInvoc "output"}
        bind = , o, submap, reset
        bind = , w, execr, ${mkModeInvoc "window"}
        bind = , w, submap, reset
        bind = , r, execr, ${mkModeInvoc "region"}
        bind = , r, submap, reset

        bind = , escape, submap, reset

        submap = reset
      '';
  };

  home.packages = with pkgs; [
    wl-clipboard
  ];

}
