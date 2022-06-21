{ config, lib, ... }:

with lib; let
  cfg = config.customOpts.boot;
in {


  options = {
    method = mkOption {
      description = "The method by which to boot with. Currently only supports UEFI, not BIOS.";
      type = types.enum [ "UEFI" ];
      default = "UEFI";
    };

    silent = mkOption {
      description = "Disables and/or hides virtually all logs at boot.";
      type = types.bool;
      default = false;

    forcePause mkOption {
      description = "For now just sets systemd-boot timeout to 10000s.";
      type = types.bool;
      default = true;
  };


  config = {
    boot.loader = mkIf cfg.method == "UEFI" {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    boot.mkIf cfg.silent {
      consoleLogLevel = 0;

      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "bgrt_disable"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "boot.shell_on_fail"
      ];

      plymouth = {
        enable = true;
        theme = "breeze";
      };
    };

    boot.loader.timeout = mkIf cfg.forcePause 10000;
}




