{ pkgs, ... }:
let
  projLayout = "HDMI-A-1,highres@highr,auto,1";
  vertLayout = "${projLayout},transform,1";
in
{
  local.programs.hyprland.settings.monitor = [
    # computer mon
    "eDP-1,highres@highr,auto,1"
    # left screen
    "DP-1,highres@highr,auto,1,transform,3"
    # main screen
    "DP-2,highres@highr,auto,1"

    "HDMI-A-1,highres@highr,auto,1"
  ];
}
