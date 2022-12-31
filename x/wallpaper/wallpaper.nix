{ config, pkgs, ... }:

{
  my.home.file.".pape".source = ./papes/copland.png;
  my.xession.windowManager.i3.startup = [{
    command = "${pkgs.feh}/bin/feh --bg-fill ~/.pape";
    always = true;
    notification = false;
  }];
}

      


