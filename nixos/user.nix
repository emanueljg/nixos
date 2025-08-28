{ config, pkgs, ... }:
{
  users.users.ejg = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  security.sudo.wheelNeedsPassword = false;
}
