{ config, ... }:

{
  networking = {
    useDHCP = false;
    interfaces = {
      "enp2s0".useDHCP = true;
      "wlp5s0".useDHCP = false;
    };
  };
}
