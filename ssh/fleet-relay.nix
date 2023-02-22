{ config, ... }:

# a "fleet relay" server is a ssh server
# that is active on each host.

{

  imports = [ ./_proper-ssh.nix ];

  users.users."ejg".openssh.authorizedKeys.keyFiles = [
    ./pubkeys/id_rsa_mothership.pub
  ];

}


