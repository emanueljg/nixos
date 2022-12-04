{ config , pkgs, ... }:

{
  services.xserver.windowManager.dwm.enable = true;

  # https://nixos.wiki/wiki/St
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        configFile = super.writeText "config.h" (builtins.readFile ./config.def.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
      });
    })
  ];
}
