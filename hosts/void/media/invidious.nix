{ nixpkgs-unstable, ... }: {
  services.invidious = {
    enable = true;
    package = nixpkgs-unstable.invidious.overrideAttrs (final: old: {
      version = "0.20.1-unstable-2024-04-27";
      src = nixpkgs-unstable.fetchFromGitea {
        domain = "gitea.invidious.io";
        owner = "iv-org";
        repo = final.pname;
        fetchSubmodules = true;
        rev = "v2.20240427";
        hash = "sha256-YZ+uhn1ESuRTZxAMoxKCpxEaUfeCUqOrSr3LkdbrTkU=";
      };
    });
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
