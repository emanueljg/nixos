{ config, ... }:

# a "fleet relay" server is a ssh server
# that is active on each host.

{

  imports = [ ./_proper-ssh.nix ];

  services.openssh.banner = ''
    Welcome to ${config.networking.hostName}, Commander.
  '';

  users.users."ejg".openssh.authorizedKeys.keyFiles = [
    ./pubkeys/fleet_id_rsa.pub
  ];

}


