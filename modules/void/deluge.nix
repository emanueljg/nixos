{ config, ... }: {
  services.deluge = {
    enable = true;

    web = {
      enable = true;
    };

    declarative = true;
    config = {
      "download_location" = "/mnt/data/dl";
      "dont_count_slow_torrents" = true;
      "allow_remote" = true;
      daemon_port = 58846;
    };
    authFile = config.sops.secrets."deluge_auth".path;
  };

  sops.secrets."deluge_auth" = {
    sopsFile = ../../secrets/deluge.yaml;
    mode = "0440";
    owner = "deluge";
    group = "deluge";
  };

  networking.firewall.allowedTCPPorts = [ config.services.deluge.config.daemon_port ];

}
