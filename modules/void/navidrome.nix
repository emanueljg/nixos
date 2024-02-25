{ config, pkgs, lib, ... }:

{
  services.navidrome = {
    enable = true;
    package = pkgs.writeShellApplication {
      name = "navidrome";
      runtimeInputs = with pkgs; [ navidrome ];
      text = ''
        ND_LASTFM_APIKEY="$(cat ${config.sops.secrets."last_fm/api_key".path})" 
        ND_LASTFM_SECRET="$(cat ${config.sops.secrets."last_fm/shared_secret".path})" 
        ND_SPOTIFY_ID="$(cat ${config.sops.secrets."spotify/id".path})"
        ND_SPOTIFY_SECRET="$(cat ${config.sops.secrets."spotify/secret".path})"
        export ND_LASTFM_APIKEY
        export ND_LASTFM_SECRET
        export ND_SPOTIFY_ID
        export ND_SPOTIFY_SECRET

        navidrome "$@"
      '';
    };
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/data/audio/Music";
      BaseUrl = "https://navi.emanueljg.com";
    };
    openFirewall = true;
  };

  users.groups."navidrome" = { };

  users.users."navidrome" = {
    group = "navidrome";
    isSystemUser = true;
  };


  systemd.services.navidrome.serviceConfig = {
    DynamicUser = lib.mkForce false;
    BindReadOnlyPaths = [
      config.sops.secrets."last_fm/api_key".path
      config.sops.secrets."last_fm/shared_secret".path
      config.sops.secrets."spotify/id".path
      config.sops.secrets."spotify/secret".path
    ];
    User = "navidrome";
    Group = "navidrome";
  };

  sops.secrets = {

    "last_fm/api_key" = {
      sopsFile = ../../secrets/navidrome.yaml;
      mode = "0440";
      owner = "navidrome";
      group = "navidrome";
    };

    "last_fm/shared_secret" = {
      sopsFile = ../../secrets/navidrome.yaml;
      mode = "0440";
      owner = "navidrome";
      group = "navidrome";
    };

    "spotify/id" = {
      sopsFile = ../../secrets/navidrome.yaml;
      mode = "0440";
      owner = "navidrome";
      group = "navidrome";
    };

    "spotify/secret" = {
      sopsFile = ../../secrets/navidrome.yaml;
      mode = "0440";
      owner = "navidrome";
      group = "navidrome";
    };

  };

}

