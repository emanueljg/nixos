{ config, ... }:

# the "I'm tired of this crap and just want this to work" configuration

{

  imports = [ ./simple_ssh.nix ];

  services.openssh.settings.PermitRootLogin = "yes";

  services.openssh.banner = ''
    Welcome to ${config.networking.hostName}. 

    ***
       The configuration you are using right now is DANGEROUS.
       You should probably not use it for very long.
       Only use it if you know what you are doing.
    ***
  '';

}



