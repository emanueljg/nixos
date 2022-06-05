{ config, ... }:

{
  services.deluge = {
    enable = true;
    declarative = true;
    openFirewall = true;

    config = {
      allow_remote = true;
      daemon_port = 58846;
      download_location = "/srv/torrents/";
      max_upload_speed = 0;
      max_download_speed = 1000;
      max_active_downloading = 3;
      listen_ports = [6881 6891];
    };

    web = {
      enable = true;
      port = 34012;
      openFirewall = true;
    };

    authFile = "/config/hosts/aurelius/deluge-auth";
  };
}

