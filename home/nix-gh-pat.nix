{ config, self, ... }: {
  sops = {
    secrets.nix-gh-pat = {
      sopsFile = "${self}/secrets/nix-gh-pat.yaml";
    };
  };

  nix.extraOptions = ''
    !include ${config.sops.secrets.nix-gh-pat.path}
  '';
}

