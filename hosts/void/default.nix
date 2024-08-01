{ config, inputs, blueprints, hosts, home, nixos, ... }: {
  system = "x86_64-linux";

  specialArgs.nixpkgs = {
    inherit (inputs) nixpkgs-unstable;
  };

  parents = with blueprints; [
    base
  ];

  nixos = with nixos; [
    hw.nvidia
    wg-server

    ./configuration.nix

    ./media

    ./nginx.nix
    ./porkbun.nix

  ];
  home = with home; [
    ./hm.nix
  ];
}
