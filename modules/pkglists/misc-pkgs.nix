{ config, pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [
    xterm
    wget
    acpi
    htop
    xclip
    scrot
    nixos-option
    zip
    unzip
    efibootmgr
    parted
    pm2
    nodejs
  ];

  
}
