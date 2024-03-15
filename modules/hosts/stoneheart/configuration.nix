# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
_: {

  imports = [
    ./hardware_configuration.nix
  ];

  networking.hostName = "stoneheart"; # Define your hostname.
  system.stateVersion = "23.05"; # Did you read the comment?
  my.home.stateVersion = "23.05";
}
