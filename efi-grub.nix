{ config, ... }:

{
  boot = {
    kernelParams = [ "quiet" "splash" ];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        device = "nodev";
        extraConfig = ''
          GRUB_HIDDEN_TIMEOUT=0
          GRUB_HIDDEN_TIMEOUT_QUIET=true
        '';
      };
    };
  };
}
