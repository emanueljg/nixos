{ config, pkgs, ... }:

{
  my.home.packages = with pkgs; [
    dmenu
    i3status
    i3lock
    xclip
    vegur
    material-design-icons
    feh
    mpv
    pv
    jetbrains-mono
    appimage-run
    mupdf
    jq
    pywal
  ];
}
