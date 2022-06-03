{ config, ... }:

{
  imports = 
    [
      ./COMMON.nix

      ../system/silent-boot.nix
      ../system/anti-intel-screentear.nix
      ../system/fast-x.nix
    ];
    boot = {
      resumeDevice = "/dev/sda2";
    };
  networking = {
    hostName = "seneca";
    useDHCP = false;
    interfaces = {
      enp0s31f6.useDHCP = false;
      wlan0.useDHCP = true;
    };
  }; 
  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      # don't forget the binary DL blob!
      videoDrivers = [ "displaylink" ];  
    };
    logind.lidSwitch = "ignore";
  };
  hardware.bluetooth.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
