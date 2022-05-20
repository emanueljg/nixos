{ config, pkgs, ... }:

{
  networking.wireless = {
    enable = true;
    networks = {
      "comhem_8726A1" = {
        psk = "42ny8xh8";
      };
    };
  };
}
