{ pkgs, ... }: {
  my.home.packages = with pkgs; [
    dmenu
    i3status
    i3lock
    xclip
    vegur
    material-design-icons
    feh
    pv
    jetbrains-mono
    mupdf
    openssl
    scrot
    (mpv.override {
      scripts = [ mpvScripts.webtorrent-mpv-hook ];
    })
    jmtpfs
    arandr
    deluge
  ];
}
