{ config, packages, pkgs, lib, self, ... }:

# merge like this for readability reasons so we can have monitor let-bindings in a narrower scope
lib.mkMerge [

  {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = packages.hyprland;
      xwayland.enable = true;
      plugins = [ packages.hy3 ];
      settings = {
        "$menu" = "${lib.getExe config.programs.wofi.package} --show run";
        "$terminal" = "kitty";
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

          "5,monitor:HDMI-A-1"
          "6,monitor:HDMI-A-1"

          "7,monitor:DP-1"
          "8,monitor:DP-1"

          "9,monitor:eDP-1"
        ];
        misc = {
          force_default_wallpaper = 0;
        };

        bindm = [
          "$mod, mouse:272, movewindow"
        ];
        bind =
          let
            workspaces = builtins.map builtins.toString (lib.range 1 9);
            goto = builtins.map (ws: "$mod, ${ws}, workspace, ${ws}") workspaces;
            move = builtins.map
              (ws: "$mod SHIFT, ${ws}, movetoworkspace, ${ws}")
              workspaces;
          in
          goto ++ move ++ [
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

  (
    let
      projLayout = "HDMI-A-1,highres@highr,auto,1";
      vertLayout = "${projLayout},transform,1";
    in
    {

      wayland.windowManager.hyprland.settings.monitor = [
        # computer mon
        "eDP-1,highres@highr,auto,1"
        # left screen
        "DP-1,highres@highr,auto,1,transform,3"
        # main screen
        "DP-2,highres@highr,auto,1"
        # right screen
        vertLayout
      ];
      home.packages = [
        (pkgs.writeShellScriptBin "hyvert" "hyprctl keyword monitor '${vertLayout}'")
        (pkgs.writeShellScriptBin "hyproj" "hyprctl keyword monitor '${projLayout}'")
      ];
    }
  )
]



