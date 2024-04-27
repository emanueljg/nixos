{ config, lib, ... }: {
  options.custom.efi-grub.enable = lib.mkEnableOption "efi-grub";

  config = lib.mkIf config.custom.efi-grub.enable {
    boot = {
      #kernelParams = [ "quiet" "splash" ];
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 10;
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          extraConfig = ''
            GRUB_HIDDEN_TIMEOUT=10
            GRUB_HIDDEN_TIMEOUT_QUIET=false
          '';
        };
      };
    };
  };
}
