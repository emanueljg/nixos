{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;
}
