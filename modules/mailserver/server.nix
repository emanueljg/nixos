{ config, ... }:
let
  release = "nixos-23.05";
  inherit
    (import ./secrets.nix)
    serverSecret
    sopsCfg
    ;
in
{
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz";
      # This hash needs to be updated
      sha256 = "sha256:1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
    })
  ];

  sops.secrets.${serverSecret} = {
    inherit (sopsCfg) sopsFile mode;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "emanueljohnsongodin@gmail.com";

  mailserver = {
    enable = true;
    fqdn = "emanueljg.com";
    domains = [ "emanueljg.com" ];
    loginAccounts = {
      "ejg@emanueljg.com" = {
        hashedPasswordFile = config.sops.secrets.${serverSecret}.path;
      };
    };
    certificateScheme = "acme-nginx";
  };

  services.dovecot2.extraConfig = ''
    imap_idle_notify_interval = 5 secs
  '';
}
