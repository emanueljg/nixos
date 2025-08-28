{ pkgs, lib, ... }:
{
  services.rutorrent = {
    enable = true;
    hostName = "rutorrent.void";
    plugins = [
      "_getdir"
      "_task"
      "edit"
      "httprpc"
      "create"
      "datadir"
      "autotools"
      "geoip"
      "diskspace"
      "source"
      "mediainfo"
      "filedrop"
      "check_port"
      "spectrogram"
      "lookat"
      "theme"
      "bulk_magnet"
    ];
    nginx.enable = true;
  };

  # systemd.services.rtorrent-setup.script = lib.mkAfter ''
  #   install -m755 ${
  # '';

}
