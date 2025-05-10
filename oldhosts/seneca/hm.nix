{ config, pkgs, ... }: {
  home.stateVersion = "22.11";
  home.username = "ejg";
  home.homeDirectory = "/home/ejg";
  nix.package = pkgs.nix;
  home.shellAliases.hm =
    "home-manager switch --flake path:/etc/nixos#seneca";
  programs.home-manager.enable = true;
}
