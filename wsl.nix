{ lib, pkgs, config, modulesPath, nixos-wsl, ... }:

#with lib;
#let
#  nixos-wsl = import ./nixos-wsl;
#in
{
  imports = [
     nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "DESKTOP-N9J57NT";

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "ejg";
    startMenuLaunchers = true;
    nativeSystemd = true;   

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };
}
