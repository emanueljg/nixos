{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Stockholm";
  i18n = let
    en = "en_US.UTF-8";
    sv = "sv_SE.UTF-8";
  in {
    defaultLocale = en;
    extraLocaleSettings = {
      LC_TIME = sv;
      LC_MONETARY = sv;
      LC_PAPER = sv;
      LC_NAME = sv;
      LC_TELEPHONE = sv;
    };
  };
  # tty keyboard
  console.keyMap = "sv-latin1";
  # x keyboard
  services.xserver.layout = "se";
}
