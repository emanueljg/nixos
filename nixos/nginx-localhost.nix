_: {
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "emanueljohnsongodin@gmail.com";
  # };

  # networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    virtualHosts."localhost".locations."/" = {
      root = "/var/www";
      extraConfig = ''
        allow all;
      '';
    };
  };
}
