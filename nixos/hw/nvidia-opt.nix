{ config, lib, ... }: {

  options.custom.nvidia = {
    enable = mkEnableOption "nvidia";
  };

  config = mkIf config.custom.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.allowUnfree = true;
    hardware.opengl.enable = true;
  };

}
