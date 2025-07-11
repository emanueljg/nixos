{ lib, config, ... }:
let
  cfg = config.local.access-tokens;
in
{
  options.local.access-tokens = {
    enable = lib.mkEnableOption "";
    tokens = lib.mkOption {
      type = with lib.types; attrsOf path;
    };
  };

  config = lib.mkIf cfg.enable {
    nix.extraOptions = builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (host: extraCfgFile:
        "!include ${extraCfgFile}"
      )
    );
  };
} 
