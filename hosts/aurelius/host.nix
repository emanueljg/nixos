{ config, ... }:

{
  imports =
    [
      ../SHARED/host.nix
      ./hardware-configuration.nix
    ];
  networking = {
    hostName = "aurelius";
    interfaces = {
      wlp2s0.useDHCP = true;
      eno1.useDHCP = false;
    };
  };
}

