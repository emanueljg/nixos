{
  nixpkgs',
  pkgs,
  other,
  lib,
  ...
}:
let

  # I'm sure this'll become upstreamed in the future,
  # so I don't expect this clunky let-binding to exist for long
  invidious-companion = pkgs.callPackage ./invidious-companion.nix { };

in
{
  nixpkgs.overlays = [
    other.nix-deno.overlays.default
  ];
  environment.systemPackages = [
    invidious-companion
  ];
  services.invidious = {
    enable = true;
    package = nixpkgs'.nixos-unstable.invidious;
    # required for invidious to work
    sig-helper = {
      enable = true;
      package = nixpkgs'.nixos-unstable.inv-sig-helper;
    };
    domain = "yt.emanueljg.com";
    settings = {
      external_port = 80;
      https_only = true;

      db =
        let
          name = "invidious";
        in
        {
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
