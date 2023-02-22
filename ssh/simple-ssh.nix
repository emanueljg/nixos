{ config, ... }:

# simple ssh configuration for when you are in the middle
# of setting up ssh and just want it to work.

{

  imports = [ ./_ssh.nix ];

  services.openssh.settings = {
    PasswordAuthentication = true;
    KbdInteractiveAuthentication = true; 
  };

}
