{ config, lib, ... }:
let cfg = config.custom.stay-awake; in with lib; {
  options.custom.stay-awake.enable = mkEnableOption "stay-awake";

  config = mkIf cfg.enable {
    services.logind.lidSwitch = "ignore";

    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
