{ config, pkgs, lib, ... }:

let dwm = pkgs.dwm; in {

    environment.systemPackages = with pkgs; [
      (dwm.overrideAttrs (oldAttrs: rec {
        configFile = writeText "config.def.h" (builtins.readFile ./config.h);
        postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
      }))
    ];

  services.xserver.windowManager.session = [{
    name = "dwm";
    start = ''
      ${dwm}/bin/dwm &
      waitPID=$!
    '';
  }];
}
