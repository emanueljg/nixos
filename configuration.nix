{ config, pkgs, ... }:

{
  imports =
    [ 
    ./hosts/seneca.nix
    ./home/home.nix
    ];
}

