{ pkgs, ... }: {
  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    dev = true;
    address = "0.0.0.0";
    devRootTokenID = "root";
  };
}
