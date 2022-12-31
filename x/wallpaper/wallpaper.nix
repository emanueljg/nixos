{ config, pkgs, ... }:

{
  my.home.file.".pape".source = ./papes/copland.png;
  my.xsession.windowManager.i3.config.startup = [{
    command = "${pkgs.feh}/bin/feh --bg-fill ~/.pape";
    always = true;
    notification = false;
  }];
}

      


