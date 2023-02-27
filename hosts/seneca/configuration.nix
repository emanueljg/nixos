{ config, ... }:

{
  imports = [
    ./hardware_configuration.nix
    ./drive.nix
  ];

  networking.hostName = "seneca";

  system.stateVersion = "22.05";
  my.home.stateVersion = "22.05";
}
