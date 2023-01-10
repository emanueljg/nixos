{ config, pkgs, lib, papes, ... }:



let 
  pape = "copland.png";
  papePath = "${papes}/${pape}"; 
in {
  nixpkgs.overlays = [(self: super: {
    pywal = super.pywal.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [(
        super.python3Packages.toPythonModule super.colorz
      )];
    });
  })];

  my.programs.pywal.enable = true;

 # my.home.packages = with pkgs; [ pywal ];

  my.home.shellAliases."mkpape" =
  let
    wal = "${pkgs.pywal}/bin/wal";
  in
    "${wal} -c && ${wal} --backend colorz -i /home/ejg/.pape";
  #my.programs.pywal.enable = true;
  my.home.file.".pape" = {
    source =
      if builtins.pathExists papePath 
      then papePath
      else pkgs.nixos-artwork.wallpapers.simple-light-gray.src;
    onChange = "${pkgs.i3}/bin/i3-msg restart";
  };

  my.xsession.windowManager.i3.config.startup = [
    ({
      command = "${pkgs.feh}/bin/feh --bg-fill ~/.pape";
      always = true;
      notification = false; 
     })
    ({
      command = config.my.home.shellAliases.mkpape;
      always = true;
      notification = false;
    })
  ];

  warnings =
    lib.lists.optional
      (!builtins.pathExists papePath)
      ("Wallpaper '${pape}' does not exist. " +
       "Defaulting to stock wallpaper...");
}

      


