{ config, pkgs, lib, ... }:

{
  imports = 
    [
      ../../parts/system/uefi.nix
      ../../parts/system/locale.nix

      ../../parts/home/hm.nix
      ../../parts/home/env.nix
      
      ../../parts/home/programs/rtorrent/rtorrent.nix
      ../../parts/home/programs/neovim/neovim.nix
      ../../parts/home/programs/git/git.nix
    ];

  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-v32n";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  networking = {
    useDHCP = false;
    wireless.enable = false;
    networkmanager.enable = true;
  };

  users.users.ejg = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    xterm
    wget
    acpi
    htop
    cryptsetup
    xclip
  ];

  my = {
    home.keyboard = null;
    fonts.fontconfig.enable = lib.mkOverride 0 true;
  };

  system.stateVersion = "21.11";
}
