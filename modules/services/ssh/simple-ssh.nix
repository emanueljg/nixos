{ config, lib, ... }:

# simple ssh configuration for when you are in the middle
# of setting up ssh and just want it to work.

{

  imports = [ ./_ssh.nix ];

  services.openssh.settings = {
    PasswordAuthentication = lib.mkForce true;
    KbdInteractiveAuthentication = lib.mkForce true; 
  };

}
