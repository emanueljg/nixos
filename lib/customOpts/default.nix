{ config, lib, ... }:

with lib; let
  cfg = config.customOpts.gfx;
in {


  imports = [
    ./x.nix
  ];

  options = {
    enable = mkEnableOption {
      description = "a system GUI.";
    };

    method = mkOption {
      description = "The method by which to serve the GUI. Currently only supports X, not Wayland.";
      type = types.enum [ "x" ];
      default = "x";
    };

  config = mkIf cfg.enable {
    if (cfg.method == "x") then {
      x.enable = true;
    } else {
      null # wayland not implemented yet
    ;


      
