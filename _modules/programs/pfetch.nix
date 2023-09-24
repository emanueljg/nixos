{ config, pkgs, ... }:

{
  my.home = {
    packages = [ pkgs.pfetch ];
    shellAliases."pf" = "echo && pfetch"; # inserts a newline before pfetch 

    sessionVariables = {
      PF_INFO = "ascii os host kernel wm editor pkgs memory";
      PF_COL1 = 6;
      PF_COL2 = 4; 
      PF_COL3 = 4;
    };
  };
}
