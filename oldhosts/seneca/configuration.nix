# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, packages, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "seneca"; # Define your hostname.
  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
  console = lib.mkForce {
    keyMap = "us";
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  system.stateVersion = "23.11";

}

