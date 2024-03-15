{ pkgs, ... }: {
  my.home.packages = with pkgs; [
    dmenu
    xclip
    feh
    mupdf
    openssl
    scrot
    (mpv.override {
      scripts = [ mpvScripts.webtorrent-mpv-hook ];
    })
    jmtpfs
    arandr
  ];
}
