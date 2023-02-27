{ config, ... }:


{
  my.home.shellAliases."msh" = 
    "ssh ejg@192.168.0.2 -i ~/.ssh/id_rsa_mothership";

  my.home.shellAliases."scsh" = 
    "ssh ejg@192.168.0.4 -i ~/.ssh/id_rsa_mothership";
}
