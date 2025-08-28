{ lib, ... }:
{
  services.rtorrent = {
    enable = true;
    port = 59823;
    downloadDir = "/mnt/data/dl";
    openFirewall = true;
    configText = builtins.readFile ./rtorrent.rc;
  };
  networking.firewall.allowedUDPPorts = [
    62882
    59823
  ];
}
