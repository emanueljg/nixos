{ config, pkgs, ... }:

# a mothership host both needs to run an ssh server on itself only listening to inward
# localhost requests (due to support how colmena works) but also of course contain
# some necessary client tweaks to connect to the fleet.

{
  # server settings
  imports = [ ./fleet-relay.nix ];

  services.openssh.listenAddresses = [
    { addr = "127.0.0.1"; port = 22; }
  ];

  # client settings


  my.home.sessionVariables."SSH_CONFIG_FILE" = 
    pkgs.writeText "colmena-ssh-config" ''
      Host *
        IdentityFile ~/.ssh/id_rsa_mothership
    '';
}
