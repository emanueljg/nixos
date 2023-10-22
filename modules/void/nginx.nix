{ config, ... }: {

  security.acme = {
    acceptTerms = true;
    email = "emanueljohnsongodin@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
    };        
  };
}
