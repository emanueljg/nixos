{ config, bandcamp-artist-dl, ... }: {

  imports = [ bandcamp-artist-dl.nixosModules.default ];

  services.bandcamp-artist-dl = {
    enable = true;

    jobDefaults = {

      email = let
        inherit (import ./mailserver/secrets.nix) clientSecret;
      in {
        address = "emanueljohnsongodin@gmail.com";
        passwordFile = config.sops.secrets.${clientSecret}.path;
      };

      dirs = {
        download = "/mnt/data/bandcamp";
        unzip = "/mnt/data/audio/Music";
      };

      verbosity = "-vv";

    };

    jobs = [
      ({ artist = "haircutsformen"; })
      ({ artist = "triple-q"; })
      ("macroblank")
    ];

  };

}
