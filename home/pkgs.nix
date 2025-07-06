{ pkgs, ... }: {
  home.packages = with pkgs; [
    dmenu
    feh
    mupdf
    openssl
    scrot
    (mpv.override {
      scripts = [ mpvScripts.webtorrent-mpv-hook ];
    })
    jmtpfs
    arandr
    tldr
  ];
}
