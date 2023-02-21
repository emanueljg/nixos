{ config, porkbun-ddns, ... }:

{
  imports = [
    porkbun-ddns.nixosModules.default
  ];

  services.porkbun-ddns = {
    enable = true;
    rootDomain = "emanueljg.com";
    subDomain = "*";
    configPath = "/var/lib/porkbun-ddns.json";
  };
}
