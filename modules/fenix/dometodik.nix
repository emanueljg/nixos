{ dometodik, ... }: {
  imports = [ dometodik.nixosModules.default ];

  services.dometodik = {
    enable = true;
    openFirewall = true;
  };

  # setup reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."boxedfenix.xyz" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8000";
    };
  };

  # formalities
  security.acme = {
    defaults.email = "emanueljohnsongodin@gmail.com";
    acceptTerms = true;
  };

}
