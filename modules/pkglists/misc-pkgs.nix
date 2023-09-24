{ config, pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [
    xterm
    wget
    acpi
    htop
    scrot
    nixos-option
    zip
    unzip
    efibootmgr
    parted
    tree
  ];

  
}
