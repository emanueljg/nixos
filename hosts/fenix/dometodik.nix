{ pkgs, ... }: {
  systemd.services."lumia" = {
    wantedBy = [ "multi-user.target" ];  # start on boot
    after = [ "network.target" ];
    serviceConfig = { User = "ejg"; Group = "users"; };
    path = with pkgs; [ 
      git 
      bash 
    ];
    script = ''
      export ROOT_DIR=$(mktemp -d)

      git clone https://github.com/emanueljg/demo-deploy-action $ROOT_DIR
      cd $ROOT_DIR
      npm install
      node server.js
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443  ];

  # setup reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."boxedfenix.xyz" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:3000";
    };
  };

  # formalities
  security.acme = {
    defaults.email = "emanueljohnsongodin@gmail.com";
    acceptTerms = true;
  };

}
