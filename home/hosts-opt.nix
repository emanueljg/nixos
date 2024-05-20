{ config, lib, ... }: {
  options.custom.hosts =
    let
      hostOptions = lib.types.submodule ({ ... }@submod: {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          ip = lib.mkOption { type = lib.types.str; };
          addr = lib.mkOption {
            type = lib.types.str;
            default = submod.config.id;
          };
        };
        in {
        defaults =

          .enable = lib.mkEnableOption "efi-grub";

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
