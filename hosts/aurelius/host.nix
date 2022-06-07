{ config, ... }:

{
  imports =
    [
      ../SHARED/host.nix
      ./hardware-configuration.nix
      ./openssh.nix
      ./deluge.nix
      ./jellyfin-docker.nix
    ];
  networking = {
    firewall.enable = false;
    hostName = "aurelius";
    networkmanager.enable = false;

    interfaces = {
      wlp2s0.useDHCP = true;
      eno1 = {
        useDHCP = false;
        ipv4 = {
          addresses = [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
        };
      };
    };

    wireless = {
      enable = true;
      networks = {
        "comhem_8726A1" = {
          psk = "42ny8xh8";
        };
      };
    };

    defaultGateway =  {
      address = "192.168.0.1";
      interface = "wlp2s0";
    };

  };
}

