{ config
, pkgs
, ...
}: {
  services.rtorrent = {
    enable = true;
    dataDir = "/mnt/data/rtorrent";
    downloadDir = "/home/ejg/rtorrent-dl";
    openFirewall = true;
    group = "lighttpd";
    # configText = ''
    #   # scgi_local = ${config.services.rtorrent.rpcSocket}
    # '';
  };
  services.lighttpd = {
    enable = true;
    extraConfig = ''
      server.modules += ( "mod_scgi" )
      scgi.server = (
                      "/RPC2" =>
                        ( "127.0.0.1" =>
                          (
                            "socket" => "${config.services.rtorrent.rpcSocket}",
                            "check-local" => "disable",
                            "disable-time" => 0,  # don't disable scgi if connection fails
                          )
                        )
                    )
    '';
  };
  # services.nginx = {
  #   enable = true;
  #   virtualHosts."localhost" = {
  #     locations."/RPC2".extraConfig = ''
  #       scgi_pass   127.0.0.1:5000;
  #       include     scgi_vars;
  #       scgi_var    SCRIPT_NAME  /RPC2;
  #     '';
  #   };
  # };
  my.home.packages = with pkgs; [ rtorrent ];
}
