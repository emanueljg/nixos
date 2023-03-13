{ config, lib, porkbun-ddns, ... }:

{
  imports = [
    porkbun-ddns.nixosModules.default
  ];

  sops.secrets."porkbun-ddns.json" = {
    sopsFile = ./secrets/crown/porkbun-ddns.json;
    format = "binary";
    mode = "0440";
    owner = config.services.porkbun-ddns.user;
    group = config.services.porkbun-ddns.group;
  };

  services.porkbun-ddns = {
    enable = true;
    defaultApiConfig = "/run/secrets/porkbun-ddns.json";
    jobs = let rootDomain = "emanueljg.com"; in {
      "main-domain" = { inherit rootDomain; subDomain = null; };
      "all-subdomains" = { inherit rootDomain; subDomain = "*"; };
    };
  };
}
