{ config, pkgs, lib, modulesPath, ... }:

let
  inherit (import /config/cfg.nix { 
    inherit config;
    inherit pkgs;
    inherit lib; 
    inherit modulesPath;

    system = "seneca-docked"; 
  }) mkKnobs;
in { imports = [ ./seneca.nix ] ++ mkKnobs; }

