{ config, bandcamp-artist-dl, pkgs, ... }: {

  imports = [ bandcamp-artist-dl.nixosModules.default ];

  environment.systemPackages = [ pkgs.samba ];

  services.bandcamp-artist-dl = {
    enable = true;

    jobDefaults = let
      inherit (import ./mailserver/secrets.nix) clientSecret;
    in {
      emailAddress = "ejg@emanueljg.com";
      passwordFile = config.sops.secrets.${clientSecret}.path;

      downloadDir = "/mnt/data/bandcamp";
      unzipDir = "/mnt/data/audio/Music";

      # maxDownloadWorkers = 1;

      verbosity = "-vv";
    };

    jobs = [
      # classics
      "triple-q"
      "pluffaduff"
      "elhuervo"
      "2mellomakes"

      # future funk
      "saintpepsi"
      "winbdows96"
      "hotsingles"
      "evexi"
      "fibre"
      "strawberrystation"
      "melon-ade"
      "htna"
      "tsunderealley"
      
      # barber beats
      "haircutsformen"
      "macroblank"
      "vinntash"
      "obliqueoccasions"
      "snowpointlounge"
      "visceraandvapor"  # GORE
      "i-am-monodrome"
      "modestbydefault"
      "slowerpace"
      "anonimantonim"
      "majestic12"
      "d4rkn3ss666"
      "peermanentzeeimp"
      "maykretch"
    ];

  };

}
