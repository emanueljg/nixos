{ config, ... }:

{
  imports = [
    ./hardware_configuration.nix
    ./screens.nix
  ];

  networking.hostName = "void";

  system.stateVersion = "22.11";
  my.home.stateVersion = "22.11";
}