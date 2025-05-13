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
  };


  nixos = with nixos; [
    hw.nvidia
    hw.void

    sonarr
    invidious
    jellyfin
    navidrome
    rutorrent
    rtorrent.default
    nginx
    porkbun
    stateversions."22-11"

  ];
  home = with home; [
    homes.void
  ];
}
