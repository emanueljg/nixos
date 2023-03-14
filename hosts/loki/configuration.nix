# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware_configuration.nix ];

  networking.hostName = "loki"; # Define your hostname.

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # we are using nodev because of nixos_lustrate install method
  # even though we are on bios and not on efi.
  boot.loader.grub.device = "nodev"; 

  system.stateVersion = "23.05"; # Did you read the comment?
  my.home.stateVersion = "23.05"; # Did you read the comment?
}

