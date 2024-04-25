{ config, pkgs, ... }: {
  home.stateVersion = "23.11";
  home.username = "ejohnso3";
  home.homeDirectory = "/home/ejohnso3";
  nix.package = pkgs.nix;
  home.shellAliases.hm =
    "home-manager switch --flake ${config.home.homeDirectory}/nixos#oakleaf";
  programs.home-manager.enable = true;
}
