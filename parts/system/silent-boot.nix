{ config, pkgs, ... }:

{
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      timeout = 0;
    };
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
}
