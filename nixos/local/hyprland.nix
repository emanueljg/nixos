{
  config,
  lib,
  pkgs,
  ...
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
            nullOr (oneOf [
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
      ]
      ++ lib.optionals cfg.sourceFirst [ "source" ];
      example = [
        "$"
        "bezier"
      ];
      description = ''
        List of prefix of attributes to source at the top of the config.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    local.wrap.wraps."hyprland" = {
      pkg = cfg.package;
      bins."Hyprland".flags."--config".path =
        let
          pluginsToHyprconf =
            plugins:
            config.local.lib.toHyprConf {
              attrs = {
                "exec-once" =
                  let
                    mkEntry =
                      entry: if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else entry;
                  in
                  map (p: "hyprctl plugin load ${mkEntry p}") cfg.plugins;
              };
              inherit (cfg) importantPrefixes;
            };
        in
        lib.optionalString (cfg.plugins != [ ]) (pluginsToHyprconf cfg.plugins)
        + lib.optionalString (cfg.settings != { }) (
          config.local.lib.toHyprConf {
            attrs = cfg.settings;
            inherit (cfg) importantPrefixes;
          }
        )
        + lib.optionalString (cfg.extraConfig != "") cfg.extraConfig;
    };

    programs.hyprland = {
      enable = true;
      package =
        (pkgs.callPackage (
          {
            enableXWayland ? false,
          }:
          config.local.wrap.wraps."hyprland".finalPackage.override {
            wrappedPkg = config.local.wrap.wraps."hyprland".pkg.override {
              inherit enableXWayland;
            };
          }
        ) { }).overrideAttrs
          (prev: {
            inherit (prev.passthru.wrapped) version;
          });
      withUWSM = true;
      xwayland.enable = config.local.programs.xwayland.enable;
    };
  };
}
