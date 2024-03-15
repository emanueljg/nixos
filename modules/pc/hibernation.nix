{ config, pkgs, lib, ... }:
let cfg = config.custom.hibernation; in with lib; {

  options.custom.hibernation.enable = mkEnableOption "hibernation";

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.pmutils ];
    my.home.shellAliases."hib" = "sudo pm-hibernate";

    boot.resumeDevice = (builtins.head config.swapDevices)."device";
  };
}
