{ config, ... }: {

  security.acme = {
    acceptTerms = true;
    defaults.email = "emanueljohnsongodin@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 81 443 ];
  # factorio
  networking.firewall.allowedUDPPorts = [ 34197 ];

  services.nginx = let
    domain = "emanueljg.com";
    mkFQDN = subdomain: "${subdomain}.${domain}";
    defaults = {
      enableACME = true;
      forceSSL = true;
    };
    mkDefaultsLocation = port: {
      locations = {
        "/".proxyPass = "http://127.0.0.1:${port}";
      };
    };

    mkAllDefaults = port: defaults // (mkDefaultsLocation port);
      
  in {
    enable = true;
    virtualHosts = {
      ${mkFQDN "lib"} = mkAllDefaults "8096"; 
      ${mkFQDN "dir"} = defaults // {
        locations = {
          "/shared" = {
            root = "/var/lib";
            extraConfig = ''
              allow 192.168.0.0/24;
              deny all;
              autoindex on;
            '';
          };
        };
      };
    };        
  };
}
