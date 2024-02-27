{ lib, pkgs, ... }: {
  my.xsession.windowManager.i3.config.startup = lib.mkForce [
    {
      command = "${lib.getBin pkgs.feh} ${lib.cli.toGNUCommandLineShell {} {
        output = "eDP-1";
        bg = true;
      }} ~/papes/tavern.jpg";
      always = true;
      notification = false;
    }
  ];
}
