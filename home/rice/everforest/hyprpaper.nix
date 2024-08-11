{ self, ... }: {

  services.hyprpaper = {
    enable = true;
    settings =
      let
        wallpaper = "lwa0.png";
        path = "${self}/wallpapers/${wallpaper}";
      in
      {
        splash = false;
        preload = path;
        wallpaper = [
          ",${path}"
        ];
      };
  };
}
