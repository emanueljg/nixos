{ config, ... }:

# the "I'm tired of this crap and just want this to work" configuration

{

  imports = [ ./simple_ssh.nix ];

  services.openssh.settings.PermitRootLogin = "yes";

}



