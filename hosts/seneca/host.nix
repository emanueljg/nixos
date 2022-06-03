{ config, pkgs, ... }:

{
  imports = 
    [
      ../SHARED/host.nix
      ./hardware-configuration.nix

      ../../parts/system/silent-boot.nix
      ../../parts/system/anti-intel-screentear.nix
      ../../parts/system/fast-x.nix

      ../../parts/home/programs/autorandr/autorandr.nix
      ../../parts/home/programs/rtorrent/rtorrent.nix
      ../../parts/home/programs/qutebrowser/qutebrowser.nix
      ../../parts/home/programs/i3/i3.nix
      ../../parts/home/programs/kitty/kitty.nix
    ];

  boot = {
      resumeDevice = "/dev/sda2";
  };

  networking = {
    hostName = "seneca";
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

  my.xsession.enable = true;

  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;
  security.sudo.wheelNeedsPassword = false;

  my.home.packages = with pkgs; [
    dmenu
    i3status
    i3lock
    xclip
    vegur
    material-design-icons
    feh
    mpv
    pv
    jetbrains-mono
  ];
}
