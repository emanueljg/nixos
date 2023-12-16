{ pkgs, lib, ... }: let qbit = pkgs.qbittorrent; in {

  my.home.packages = [
    qbit
  ];

  my.xsession.windowManager.i3.config = {
    assigns."10" = [{ class = "qBittorrent"; }];
    startup = [
      {
        command = "${qbit}/bin/qbittorrent";
        always = false;
        notification = true;
      }
    ];
  };

}
