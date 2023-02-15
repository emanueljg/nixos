{ config, porkbun-ddns, ... }:

{
  imports = [
    porkbun-ddns.nixosModules.default
  ];

  services.porkbun-ddns = {
    enable = true;
    rootDomain = "emanueljg.com";
    configPath = "/var/lib/porkbun-ddns.json"
  };
}
