{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Stockholm";
  i18n = {
    extraLocaleSettings = {
      # not using:
      # LANGUAGES
      # LC_IDENTIFICATION
      LANG =           "en_US.UTF-8";
      LC_ADDRESS =     "sv_SE.UTF-8";
      LC_COLLATE =     "C"          ;
      LC_CTYPE =       "en_US.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MESSAGES =    "en_US.UTF-8";
      LC_MONETARY =    "sv_SE.UTF-8";
      LC_NAME =        "sv_SE.UTF-8";
      LC_NUMERIC =     "sv_SE.UTF-8";
      LC_PAPER =       "sv_SE.UTF-8";
      LC_TELEPHONE =   "sv_SE.UTF-8";
      LC_TIME =        "sv_SE.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];
  };
}
