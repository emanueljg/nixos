{ config, inputs, blueprints, hosts, home, nixos, ... }:
let
  system = "x86_64-linux";
in
{
  inherit system;

  specialArgs.nixpkgs = {
    inherit (inputs) nixos-unstable;
    inherit (inputs) master;
  };

  specialArgs.nixosModules = {
    yt-dlp-web-ui = inputs.yt-dlp-web-ui.nixosModules.default;
    archiver = inputs.archiver.nixosModules.default;
  };

  specialArgs.other = {
    archiver-lib = inputs.archiver.lib.${system};
  };

  parents = with blueprints; [
    base
  ];

  nixos = with nixos; [
    hw.nvidia
    wg-server

    ./configuration.nix

    ./sonarr.nix
    ./invidious.nix
    ./jellyfin.nix
    ./navidrome.nix
    # ./flood.nix
    ./rutorrent.nix
    ./rtorrent

    ./archiver

    ./nginx.nix
    ./porkbun.nix
    ./yt-dlp-web-ui.nix

  ];
  home = with home; [
    ./hm.nix
  ];
}
