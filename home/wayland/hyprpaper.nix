{ self, ... }: {
  services.hyprpaper = {
    enable = true;
    settings =
      let
        wallpaper = "${self}/wallpapers/pixel-grass.png";
      in
      {
        splash = false;
        preload = wallpaper;
        wallpaper = [
          ",${wallpaper}"
        ];
      };
  };
}
