{ config, lib, ... }: 

# core ssh module. 
# cannot be imported and used directly; needs to be overridden

with lib; {

  services.openssh = {

    enable = true;

    settings = {
      PasswordAuthentication = mkDefault false;
      KbdInteractiveAuthentication = mkDefault false;
      PermitRootLogin = mkDefault "no";
    };

    banner = mkDefault ''
      Welcome to ${config.networking.hostName}.

      You should never be able to remote into a server
      using this configuration. Something went wrong.
      Check the configuration for errors.
    '';

  };

  users.users."ejg".openssh.authorizedKeys = {
    keyFiles = mkDefault [];
    # keys is a dumb option, we signal this by using a non-default prio.
    keys = []; 
  };

}
