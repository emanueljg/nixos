{ config, pkgs, devop22, ... }:

{
  imports = [
    devop22.nixosModules.default
  ];

  services.devop22 = {
    enable = true;
    settingsPath = "/run/secrets/app1-infrastruktur-settings.json";
    stack1 = {
      enable = true;
      addSeeder = true;
    };
    stack2 = {
      enable = false;
    };
  };

  sops.secrets."app1-infrastruktur-settings.json" = {
    sopsFile = ../../secrets/app1-infrastruktur-settings.json;
    format = "binary";  
    mode = "0440";
    owner = config.services.devop22.user;
    group = config.services.devop22.group;
  };

}
