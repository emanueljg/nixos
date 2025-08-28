{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.local.cursor;

  pointerCursorModule = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "cursor config generation";

      package = lib.mkOption {
        type = lib.types.package;
      };

      name = lib.mkOption {
        type = lib.types.str;
      };

      size = lib.mkOption {
        type = lib.types.int;
        default = 32;
      };

      gtk.enable = lib.mkEnableOption "";

      dotIcons.enable = (lib.mkEnableOption "") // {
        default = true;
      };

      hyprcursor.enable = lib.mkEnableOption "hyprcursor config generation";
    };
  };

  defaultIndexThemePackage = pkgs.writeTextFile {
    name = "index.theme";
    destination = "/share/icons/default/index.theme";
    # Set name in icons theme, for compatibility with AwesomeWM etc. See:
    # https://github.com/nix-community/home-manager/issues/2081
    # https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
    text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${cfg.name}
    '';
  };

in
{
  options.local.cursor = lib.mkOption {
    type = lib.types.nullOr pointerCursorModule;
    default = null;
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.package
        defaultIndexThemePackage
      ];
      sessionVariables = {
        XCURSOR_SIZE = cfg.size;
        XCURSOR_THEME = cfg.name;
      }
      // (lib.optionalAttrs (cfg.hyprcursor.enable) {
        HYPRCURSOR_THEME = cfg.name;
        HYPRCURSOR_SIZE = cfg.size;
      });
      etc = {
        "xdg/share/icons/default/index.theme".source =
          "${defaultIndexThemePackage}/share/icons/default/index.theme";
        "xdg/share/icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";
      };
    };
    local.gtk.cursorTheme = lib.mkIf cfg.gtk.enable {
      inherit (cfg) package name size;
    };
  };

}
