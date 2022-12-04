{ config, pkgs, ... }:

{
  my.home.packages = with pkgs; [
    android-tools
    scrcpy
  ];

  my.home.shellAliases = {
    phone = "adb connect 192.168.1.4 && scrcpy";
  };
}
