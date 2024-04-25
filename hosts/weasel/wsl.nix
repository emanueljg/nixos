{ wsl, lib, ... }: {

  imports = [
    wsl.nixosModules.default
  ];

  wsl.enable = lib.mkForce true;

  custom.efi-grub.enable = false;
}
