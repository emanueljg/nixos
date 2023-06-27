{ config, lib, ... }: 

# core ssh module. 
# cannot be imported and used directly; needs to be overridden

with lib; {

  services.openssh = {
    enable = true;
    listenAddresses = [{
      addr = "0.0.0.0";
      port = 22;
    }];
      
    settings = {
      PasswordAuthentication = mkDefault false;
      KbdInteractiveAuthentication = mkDefault false;
      PermitRootLogin = mkDefault "no";
    };
  };

  users.users."ejg".openssh.authorizedKeys = {
    keyFiles = mkDefault [];
    # keys is a dumb option, we signal this by using a non-default prio.
    keys = []; 
  };

}
