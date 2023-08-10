# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./dometodik.nix
   ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = lib.mkForce"/dev/sda"; 

  networking.hostName = "fenix"; # Define your hostname.

  services.openssh = {
    enable = true;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "22.11"; # Did you read the comment?
  my.home.stateVersion = "22.11"; # Did you read the comment?

}

