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
    (mpv.override {
      scripts = [ mpvScripts.webtorrent-mpv-hook ];
    })
    pv
    jetbrains-mono
    mupdf
    jq
    openssl
    tldr
  ];
}
