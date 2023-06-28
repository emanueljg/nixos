{ config, ... }:

{
  imports = [
    ./hardware_configuration.nix
    ./porkbun.nix
  ];

  networking.hostName = "crown";

  networking = {
    useDHCP = false;
    interfaces = {
      "enp2s0".useDHCP = true;
      "wlp5s0".useDHCP = false;
    };
  };

  system.stateVersion = "22.11";
  my.home.stateVersion = "22.11";
}
