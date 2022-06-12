{ config, pkgs, ... }:

{
  services.xserver = {
    videoDrivers = [ "modesetting" ];
   # deviceSection = ''
   #   Option "TearFree" "true"
   # '';
  };
}
