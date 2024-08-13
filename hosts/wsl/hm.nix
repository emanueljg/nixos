{ config, pkgs, ... }: {
  home.stateVersion = "24.05";
  home.username = "ejg";
  home.homeDirectory = "/home/ejg";
  nix.package = pkgs.nix;
  programs.home-manager.enable = true;
}
