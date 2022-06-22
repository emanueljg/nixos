{ config, pkgs, lib, modulesPath, ... }:

let
  inherit (import /config/cfg.nix { 
    inherit config;
    inherit pkgs;
    inherit lib; 
    inherit modulesPath;

    system = "seneca-tv"; 
  }) mkKnobs;
in { imports = [ ./seneca.nix ] ++ mkKnobs; }

