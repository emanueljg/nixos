{ self, ... }: {

  services.hyprpaper = {
    enable = true;
    settings =
      let
        # wrap papes into attrset, can't refer to let-bindings beginning with numbers
        papes = {
          # tank top 
          "qde6kq" = "${self}/wallpapers/wallhaven-qde6kq.png";
          # white dress
          "9m37g8" = "${self}/wallpapers/wallhaven-9m37g8.png";
        };
      in
      {
        splash = false;
        preload = builtins.attrValues papes;
        wallpaper = [
          "HDMI-A-1,${papes."9m37g8"}"
          "DP-2,${papes.qde6kq}"
        ];
      };
  };
}
