{ config, lib, ... }:
let cfg = config.custom.efi-grub; in with lib; {
  options.custom.efi-grub.enable = mkEnableOption "efi-grub";

  config = lib.mkIf cfg.enable {
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
