{ config, ... }:


{
  my.home.shellAliases."msh" = 
    "ssh ejg@192.168.0.2 -i ~/.ssh/fleet_id_rsa";
}
