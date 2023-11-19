{ factorio-server, ... }: {

  imports = [ factorio-server.nixosModules.default ];

  services.factorio-server = {
    enable = true;
    openFirewall = true;
    socketUser = "ejg";
  };

}
  
