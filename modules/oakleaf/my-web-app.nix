{ my-web-app, ... }: {
  imports = [
    my-web-app.nixosModules.default
  ];
  services.my-web-app = {
    enable = true;
    reverseProxy = {
      enable = true;
      virtualHost = {
        serverName = "webapp.emanueljg.com";
      };
    };
  };
}

