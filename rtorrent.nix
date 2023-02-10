{ config, ... }:

{
  services.rtorrent = {
    enable = true;
    dataDir = "/mnt/data/rtorrent";
  };
}
