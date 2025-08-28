{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.local.services.hyprpaper;
in
{

  options.local.services.hyprpaper = {
    enable = lib.mkEnableOption "";
    package = lib.mkPackageOption pkgs "hyprpaper" { };
    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {

    local.wrap.wraps."hyprpaper" = {
      pkg = cfg.package;
      bins."hyprpaper".envs."XDG_CONFIG_HOME".paths = {
        "hypr/hyprpaper.conf" = config.local.lib.toHyprConf { attrs = cfg.settings; };
      };
    };

    systemd.user.services.hyprpaper = {
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";

      serviceConfig = {
        ExecStart = lib.getExe config.local.wrap.wraps."hyprpaper".finalPackage;
        Restart = "always";
        RestartSec = "10";
      };
    };

  };
}
