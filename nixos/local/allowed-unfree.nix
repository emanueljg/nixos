{ config, lib, ... }:
let
  cfg = config.local.allowed-unfree;
in
{
  options.local.allowed-unfree = {
    enable = (lib.mkEnableOption "") // {
      default = true;
    };
    names = lib.mkOption {
      default = { };
      type = with lib.types; listOf str;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) cfg.names;
  };
}
