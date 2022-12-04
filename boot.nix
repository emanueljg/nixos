{ config, ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      device = "nodev";
    };
  };
}
