{ config, pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      displaylink = prev.displaylink.overrideAttrs (oldAttrs: {
        version = "6.0.0-24";
        src = final.fetchurl {
          url = "https://www.synaptics.com/sites/default/files/exe_files/2024-05/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.0-EXE.zip";
          name = "displaylink-600.zip";
          hash = "sha256-/HqlGvq+ahnuBCO3ScldJCZp8AX02HM8K4IfMzmducc=";
        };
        unpackPhase = ''
          unzip $src
          chmod +x displaylink-driver-${final.displaylink.version}.run
            ./displaylink-driver-${final.displaylink.version}.run --target . --noexec --nodiskspace
        '';
      });
    })
  ];
  services.xserver.videoDrivers = [
    "displaylink"
  ];
}
