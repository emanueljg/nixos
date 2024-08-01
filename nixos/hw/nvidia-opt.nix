{ config, lib, ... }: {

  options.custom.nvidia = {
    enable = lib.mkEnableOption "nvidia";
    whitelistUnfree = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to whitelist nvidia unfree packages or not.
      '';
      default = false;
    };

  };

  config = lib.mkIf config.custom.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.allowUnfree = true;
    hardware.nvidia.modesetting.enable = true;
    # powerManagement = {
    #   enable = true;
    #   finegrained = true;
    # };
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

}
