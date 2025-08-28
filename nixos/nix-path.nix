{ nixpkgs, ... }:
{
  nix.nixPath = [
    "nixpkgs=${nixpkgs.nixos-unstable}"
  ];
}
