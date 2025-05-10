{ nixpkgs, pkgs, lib, ... }: {
  services.invidious = {
    enable = true;
    package = nixpkgs.master.invidious.overrideAttrs (_: {
      doCheck = false;
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "iv-org";
        repo = "invidious";
        rev = "master";
        hash = "sha256-z+v0i32jpglu0ntKf2hJAPdwZp8nK9q8vZft0g4ozjc=";
      };
    });
    # package = nixpkgs.master.invidious;
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
