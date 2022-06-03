{ config, pkgs, ... }:

{
  services.xserver = {
    videoDrivers = [ "modesetting" ];
#    deviceSection = ''
#      Option "DRI" "2"
#      Option "TearFree" "true"
#    '';
  };
}
