{ pkgs, ... }: {
  systemd.services."dometodik" = {
    wantedBy = [ "multi-user.target" ];  # start on boot
    after = [ "network.target" ];
    # serviceConfig = { User = "ejg"; Group = "users"; };
    path = with pkgs; [ 
      nixVersions.nix_2_14
    ];
    script = "${pkgs.nixVersions.nix_2_14}/bin/nix run github:emanueljg/dometodik";
  };

  networking.firewall.allowedTCPPorts = [ 80 443  ];

  # setup reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."boxedfenix.xyz" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:8000";
    };
  };

  # formalities
  security.acme = {
    defaults.email = "emanueljohnsongodin@gmail.com";
    acceptTerms = true;
  };

}
