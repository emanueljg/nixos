{ config, pkgs, ... }:

{
  imports = 
    [
      ../hardware-configuration.nix

      ../system/uefi.nix
      ../system/locale.nix
      ../system/network.nix
    ];
  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-v32n";
  };
  hardware.opengl.enable = true;
  services.xserver.libinput.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  users.users.ejg = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    xterm
    wget
    acpi
  ];
  system.stateVersion = "21.11";
}
