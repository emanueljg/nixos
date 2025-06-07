{ config, inputs, blueprints, hosts, home, nixos, ... }:
{
  system = "x86_64-linux";

  imports = [
    blueprints.base
  ];


  specialArgs = {
    nixpkgs = {
      inherit (inputs) nixos-unstable;
    };

    nixosModules = {
      archiver = inputs.archiver.nixosModules.default;
    };

    other = {
      archiver-lib = inputs.archiver.lib.${config.system};
    };
  };


  nixos = with nixos; [
    # dns.server
    hw.nvidia
    hw.void

    sonarr
    # fuck this shit
    # invidious
    jellyfin
    navidrome
    rutorrent
    rtorrent.default
    archiver
    kavita

    nginx
    porkbun

    stateversions."22-11"

  ];
  home = with home; [
    homes.void
  ];
}
