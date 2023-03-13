{ config, ... }:

# proper use of ssh. 
# needs key files to work, do not use directly

{

  imports = [ ./_ssh.nix ];

  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

}
