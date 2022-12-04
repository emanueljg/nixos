{ config, ... }:

{
  services.logind.lidSwitch = "ignore";
  
  systemd.targets = {
    sleep.enable = false;
      suspend.enable = false;
      hybrid-sleep.enable = false;
  };
}
