{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.wireless = {
    enable = false;
    networks = {
      "comhem_8726A1" = {
        psk = "42ny8xh8";
      };
    };
  };
}
