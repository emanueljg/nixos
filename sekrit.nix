{ config, pkgs, sops-nix, ... }:

{

  imports = [
    sops-nix.nixosModules.sops
  ];

  my.home.packages = with pkgs; [ 
    pinentry.curses
    pass
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

}
