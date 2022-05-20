{ config, pkgs, ... }:

{
  services.xserver = {
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
  };
}
