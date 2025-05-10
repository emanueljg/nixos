{ pkgs, ... }: {
  services.rutorrent = {
    enable = true;
    hostName = "rutorrent.void";
    plugins = [
      "httprpc"
      "create"
      "datadir"
      "_getdir"
      "autotools"
    ];
    nginx.enable = true;
  };
}
