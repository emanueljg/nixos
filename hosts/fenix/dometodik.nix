{ pkgs, ... }: {
  systemd.services."dometodik" = {
    wantedBy = [ "multi-user.target" ];  # start on boot
    after = [ "network.target" ];
    # serviceConfig = { User = "ejg"; Group = "users"; };
    script = let 
      nix = "${pkgs.nixVersions.nix_2_14}/bin/nix";
    in "${nix} run github:emanueljg/dometodik/nix-python-package";
  };

  networking.firewall.allowedTCPPorts = [ 80 443  ];

  # setup reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."boxedfenix.xyz" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8000";
    };
  };

  # formalities
  security.acme = {
    defaults.email = "emanueljohnsongodin@gmail.com";
    acceptTerms = true;
  };

}
