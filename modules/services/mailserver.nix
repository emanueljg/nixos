{ config, pkgs, ... }: let 
  release = "nixos-23.05";
  secret = "mailserver-ejg-password";
in {
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz";
      # This hash needs to be updated
      sha256 = "sha256:1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
    })
  ];

  sops.secrets.${secret} = {
    sopsFile = ../../secrets/${secret}.yaml;
    mode = "0440";
    owner = "ejg";
    group = "wheel";
  };

  mailserver = {
    enable = true;
    fqdn = "emanueljg.com";
    domains = [ "emanueljg.com" ];
    loginAccounts = {
      "ejg@emanueljg.com" = {
         hashedPasswordFile = config.sops.secrets.${secret}.path;
       };
    };
    certificateScheme = "acme-nginx";
    maxConnectionsPerUser = 150;  # :^)
  };

  services.dovecot2.extraConfig = ''
    mail_max_userip_connections = ${toString config.mailserver.maxConnectionsPerUser}
  '';

  
}

