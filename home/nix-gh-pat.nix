{ config, self, ... }: {
  sops = {
    secrets.nix-gh-pat = {
      mode = "0440";
      sopsFile = "${self}/secrets/nix-gh-pat.yml";
    };
  };

  # nix.extraOptions = ''
  #   !include ${config.sops.secrets.nix-gh-pat.path}
  # '';
}

