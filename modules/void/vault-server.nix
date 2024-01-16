{ pkgs, ... }: {
  services.vault = {
    enable = true;
    dev = true;
    package = pkgs.vault-bin; # includes UI
    devRootTokenID = "foobarbaz";
  };
  environment.systemPackages = with pkgs; [ vault ];
}
