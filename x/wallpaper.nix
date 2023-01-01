{ config, pkgs, lib, papes, ... }:



let 
  pape = "copland.png";
  papePath = "${papes}/${pape}"; 
in {
  my.home.file.".pape" = {
    source =
      if builtins.pathExists papePath 
      then papePath
      else pkgs.nixos-artwork.wallpapers.simple-light-gray.src;
    onChange = "${pkgs.i3}/bin/i3-msg restart";
  };

  my.xsession.windowManager.i3.config.startup = [{
    command = "${pkgs.feh}/bin/feh --bg-fill ~/.pape";
    always = true;
    notification = false;
  }];

  warnings =
    lib.lists.optional
      (!builtins.pathExists papePath)
      ("Wallpaper '${pape}' does not exist. " +
       "Defaulting to stock wallpaper...");
}

      


