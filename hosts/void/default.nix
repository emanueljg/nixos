{ config, inputs, blueprints, hosts, home, nixos, ... }: {
  system = "x86_64-linux";

  specialArgs.nixpkgs = {
    inherit (inputs) nixos-unstable;
  };

  specialArgs.nixosModules = {
    yt-dlp-web-ui = inputs.yt-dlp-web-ui.nixosModules.default;
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
    ./flood.nix
    ./rtorrent


    ./nginx.nix
    ./porkbun.nix
    ./yt-dlp-web-ui.nix

  ];
  home = with home; [
    ./hm.nix
  ];
}
