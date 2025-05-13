{ nixpkgs', pkgs, lib, ... }: {
  services.invidious = {
    enable = true;
    package = nixpkgs'.nixos-unstable.invidious;
    domain = "yt.emanueljg.com";
    settings = {
      external_port = 80;
      https_only = true;

      db = let name = "invidious"; in {
        user = name;
        dbname = name;
      };

      # db = {
      #   user = "ejg";
      # };

      popular_enabled = false;
      admin = [ "root" ];
      registration_enabled = false;

      default_user_preferences = {
        dark_mode = "dark";
        feed_menu = [
          "Subscriptions"
          "Playlists"
        ];
        default_home = "Subscriptions";
        related_videos = false;
        quality = "dash";
        quality_dash = "auto";
      };
    };
  };
}
