{ config, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 34022 ];
    authorizedKeysFiles = [ "/home/ejg/.ssh/id_ed25519.pub" ];
  };
}

