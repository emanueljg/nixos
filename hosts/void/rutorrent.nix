{ pkgs, ... }: {
  services.rutorrent = {
    enable = true;
    hostName = "rutorrent.void";
    nginx.enable = true;
  };
}
