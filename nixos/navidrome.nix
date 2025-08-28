{
  config,
  pkgs,
  lib,
  self,
  ...
}:

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
      MusicFolder = "/mnt/data/audio";
      BaseUrl = "https://navi.emanueljg.com";
      "Scanner.Extractor" = "ffmpeg";
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
      "/mnt/data/dl"
    ];
    User = "navidrome";
    Group = "navidrome";
  };

  sops.secrets =
    lib.genAttrs
      [
        "last_fm/api_key"
        "last_fm/shared_secret"
        "spotify/id"
        "spotify/secret"
      ]
      (_: {
        sopsFile = "${self}/secrets/${config.networking.hostName}/navidrome.yml";
        mode = "0440";
        owner = "navidrome";
        group = "navidrome";
      });

}
