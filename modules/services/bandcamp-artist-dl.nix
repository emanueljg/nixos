{ config, bandcamp-artist-dl, ... }: {

  imports = [ bandcamp-artist-dl.nixosModules.default ];

  services.bandcamp-artist-dl = {
    enable = true;

    jobDefaults = let
      inherit (import ./mailserver/secrets.nix) clientSecret;
    in {
      emailAddress = "emanueljohnsongodin@gmail.com";
      passwordFile = config.sops.secrets.${clientSecret}.path;

      downloadDir = "/mnt/data/bandcamp";
      unzipDir = "/mnt/data/audio/Music";

      verbosity = "-vv";
    };

    jobs = [
      ({ artist = "haircutsformen"; })
      ({ artist = "triple-q"; })
      ("macroblank")
    ];

  };

}
