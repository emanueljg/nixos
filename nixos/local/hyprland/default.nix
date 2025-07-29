{ config
, lib
, pkgs
, ...
}:
let

  cfg = config.local.programs.hyprland;
in
{
  options.local.programs.hyprland = {
    enable = lib.mkEnableOption "";

    package = lib.mkPackageOption pkgs "hyprland" { };

    plugins = lib.mkOption {
      type = with lib.types; listOf (either package path);
      default = [ ];
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            nullOr
              (oneOf [
                bool
                int
                float
                str
                path
                (attrsOf valueType)
                (listOf valueType)
              ])
            // {
              description = "Hyprland configuration value";
            };
        in
        valueType;
      default = { };
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };

    sourceFirst =
      lib.mkEnableOption ''
        putting source entries at the top of the configuration
      ''
      // {
        default = true;
      };

    importantPrefixes = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "$"
        "bezier"
        "name"
      ] ++ lib.optionals cfg.sourceFirst [ "source" ];
      example = [
        "$"
        "bezier"
      ];
      description = ''
        List of prefix of attributes to source at the top of the config.
      '';
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      # config.programs.hyprland adds xwayland configuration
      # itself by doing an .override, but we're setting a symlinkJoin'd drv
      # as its package value, which fails. So we wrap it in a callPackage
      # to allow for overrides. As a bonus, we get a cleaner module.
      default = pkgs.callPackage ./_finalPackage.nix {
        _cfg = cfg;
        _config = config;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    programs.hyprland = {
      enable = true;
      package = cfg.finalPackage;
      withUWSM = true;
      xwayland.enable = config.local.programs.xwayland.enable;
    };
  };
}
