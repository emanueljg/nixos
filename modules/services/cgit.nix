{ config, pkgs, lib, ... }: 

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@emanueljg.com";
  };

  environment.systemPackages = with pkgs; [
    cgit
  ];

  services.gitea = {
    enable = true;
    rootUrl = "https://git.emanueljg.com";
    domain = "emanueljg";
    httpAddress = "127.0.0.1";
    httpPort = 3000;
  };

  services.lighttpd = {
    enable = true;
    port = 3001;
    mod_status = true;  # TODO remove debug
    cgit = {
      enable = true;
      subdir = "";
      configText = ''
        repo.url=nixos
        repo.path=/etc/nixos/.git
        repo.desc=Functional by design
      '';
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."emanueljg.com" = {
      default = true;
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        return = "403";
      };
    };
    virtualHosts."git.emanueljg.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
      };
    };
    virtualHosts."cgit.emanueljg.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
