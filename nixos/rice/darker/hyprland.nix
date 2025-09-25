{ lib, config, ... }:
{
  local.programs.hyprland.settings =
    let
      theme = config.local.themes."Everforest Dark Medium";
    in
    {
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 8;
        "col.active_border" =
          "rgb(${lib.removePrefix "#" theme.fg.statusline1}) rgb(${lib.removePrefix "#" theme.fg.statusline1}) 45deg";
        "col.inactive_border" = "rgb(${lib.removePrefix "#" theme.fg.blue})";
      };
      plugins.hy3.tabs = {
        rounding = 0;
        render_text = false;
      };
      animations = {
        enabled = false;
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
        active_opacity = 0.93;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1;

        blur = {
          enabled = true;
          size = 5;
          # brightness = 0.2;
          passes = 1;
        };
        shadow = {
          enabled = true;
        };
        # drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(1a1a1aee)";
      };

    };
}
