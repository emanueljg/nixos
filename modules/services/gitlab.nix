{ config, pkgs, lib, ... }: 

let 
  secrets = [
    "secretFile"
    "otpFile"
    "jwsFile"
    "dbFile"
  ];

  prefixSecret = secret: "gitlab/" + secret;
  prefixedSecrets = builtins.map prefixSecret secrets;
  prefixedSecretsWithRootPw = prefixedSecrets ++ [(
    prefixSecret "initialRootPasswordFile"
  )];

  secretsStub = "/run/secrets";
  secretPath = secret: secretsStub + "/" + secret;

  inherit (lib.attrsets) genAttrs;
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@emanueljg.com";
  };

  services.gitea = {
    enable = true;
    rootUrl = "https://git.emanueljg.com";
    domain = "emanueljg";
    httpAddress = "127.0.0.1";
    httpPort = 3000;
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
  };

  sops.secrets = genAttrs prefixedSecretsWithRootPw (_: {
    sopsFile = ../../secrets/crown/gitlab.yaml;
    mode = "0440";
  });

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
