{ config, homeModules, pkgs, ... }: {
  imports = [ homeModules.sops ];

  sops.gnupg.home = "${config.home.homeDirectory}/.gnupg";

  home.packages = [ pkgs.sops ];

}
    
