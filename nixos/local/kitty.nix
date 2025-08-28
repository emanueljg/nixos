{
  config,
  pkgs,
  lib,
  ...
}:
let
  # settingsFormat = pkgs.formats.toml { };
  cfg = config.local.programs.kitty;
  settingsValueType =
    with lib.types;
    oneOf [
      str
      bool
      int
      float
    ];
  toKittyConfig = lib.generators.toKeyValue {
    mkKeyValue =
      key: value:
      let
        value' = if lib.isBool value then (if value then "yes" else "no") else toString value;
      in
      "${key} ${value'}";
  };
  fontType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = with lib.types; nullOr package;
        default = null;
        example = lib.literalExpression "pkgs.dejavu_fonts";
        description = ''
          Package providing the font. This package will be installed
          to your profile. If `null` then the font
          is assumed to already be available in your profile.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        example = "DejaVu Sans";
        description = ''
          The family name of the font within the package.
        '';
      };

      size = lib.mkOption {
        type = with lib.types; nullOr number;
        default = null;
        example = "8";
        description = ''
          The size of the font.
        '';
      };
    };
  };
in
{
  options.local.programs.kitty = {
    enable = lib.mkEnableOption "kitty";
    package = lib.mkPackageOption pkgs "kitty" { };
    settings = lib.mkOption {
      type = with lib.types; attrsOf settingsValueType;
      default = { };
    };
    themeFile = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        Apply a Kitty color theme. This option takes the file name of a theme
        in `kitty-themes`, without the `.conf` suffix. See
        <https://github.com/kovidgoyal/kitty-themes/tree/master/themes> for a
        list of themes.
      '';
      example = "SpaceGray_Eighties";
    };
    font = lib.mkOption {
      type = lib.types.nullOr fontType;
      default = null;
      description = "The font to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    local.wrap.wraps."kitty" = {
      pkg = cfg.package;
      systemPackages = true;
      bins = lib.genAttrs [ "kitty" "kitten" ] (_: {
        envs."KITTY_CONFIG_DIRECTORY".paths."kitty.conf" = lib.concatStringsSep "\n" [
          # font
          (lib.optionalString (cfg.font != null) ''
            font_family ${cfg.font.name}
            ${lib.optionalString (cfg.font.size != null) "font_size ${toString cfg.font.size}"}
          '')

          # theme
          (lib.optionalString (cfg.themeFile != null) ''
            include ${pkgs.kitty-themes}/share/kitty-themes/themes/${cfg.themeFile}.conf
          '')

          # settings
          (toKittyConfig cfg.settings)
        ];
      });
    };
  };
}
