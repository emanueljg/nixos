{
  inputs,
  modules,
  configs,
  lib,
  ...
}:
cfg:
let
  parent = configs.base;
in
{

  system = "x86_64-linux";

  specialArgs = lib.recursiveUpdate parent {
    nixosModules = {
      archiver = inputs.archiver.nixosModules.default;
    };

    other = {
      archiver-lib = inputs.archiver.lib.${cfg.system};
    };
  };

  modules =
    parent.modules
    ++ (with modules; [
      hostnames.void
      lan.void
      hw.nvidia
      hw.void

      sonarr
      # fuck this shit
      # invidious
      jellyfin
      navidrome
      rutorrent
      rtorrent
      archiver
      kavita

      nginx
      porkbun

      nixos-rebuild.void

      stateversions."22-11"

    ]);
}
