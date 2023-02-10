{ config, ... }:

{
  services.invidious.enable = true;
      
  # setup ports
  services.invidious = {
    port = 34030;
    database.port = 34031;
  };

  networking.firewall.allowedTCPPorts = [ 
    config.services.invidious.port
    config.services.invidious.database.port
  ];
}
