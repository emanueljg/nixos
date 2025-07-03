{ self, config, ... }: {
  sops.secrets."fetchFromItch" = {
    sopsFile = "${self}/secrets/${config.networking.hostName}/fetchFromItch.yml";
    group = "nixbld";
    mode = "0440";
  };

  nix.settings.extra-sandbox-paths = [ config.sops.secrets."fetchFromItch".path ];
}
