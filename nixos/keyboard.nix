{
  config,
  lib,
  pkgs,
  packages,
  ...
}:

{
  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
  console = lib.mkForce {
    keyMap = "us";
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };
}
