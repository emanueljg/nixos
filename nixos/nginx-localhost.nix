_: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "emanueljohnsongodin@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # factorio
  networking.firewall.allowedUDPPorts = [ 34197 ];

  services.nginx =
    {
      enable = true;
      virtualHosts."localhost".locations."/" = {
        root = "/var/www";
        extraConfig = ''
          allow all;
          autoindex on;
        '';
      };
    };
  #     "/" = {
  #       proxyPass = "127.0.0.1:8000";
  #       root 
  #   };
  # };
  #   ${mkFQDN "lib"} = mkAllDefaults "8096";
  #   ${mkFQDN "yt"} = mkAllDefaults "3000";
  #   ${mkFQDN "navi"} = mkAllDefaults "4533";
  #   ${mkFQDN "live"} = defaults // {
  #     locations = {
  #       "/".proxyPass = "192.168.0.219:8000";
  #     };
  #   };
  #   # ${mkFQDN "sonarr"} = mkAllDefaults "8989";
  #   "dir.void" = {
  #     locations = {
  #       "/games" = {
  #         root = "/mnt/data";
  #         extraConfig = ''
  #           allow 192.168.0.0/24;
  #           deny all;
  #           autoindex on;
  #         '';
  #     };
  #   };
  # };
}
