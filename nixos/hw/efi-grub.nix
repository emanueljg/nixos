{ config, lib, ... }:
{
  boot = {
    #kernelParams = [ "quiet" "splash" ];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 10;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        # this is super slow
        # useOSProber = true;
        extraConfig = ''
          GRUB_HIDDEN_TIMEOUT=10
          GRUB_HIDDEN_TIMEOUT_QUIET=false
        '';
      };
    };
  };
}
