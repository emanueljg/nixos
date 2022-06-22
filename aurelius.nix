{ config, pkgs, lib, modulesPath, ... }:

let
  inherit (import /config/cfg.nix { 
    inherit config;
    inherit pkgs;
    inherit lib; 
    inherit modulesPath;

    system = "aurelius"; 
  }) mkKnobs;
in { imports = mkKnobs; }

