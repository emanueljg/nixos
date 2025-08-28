{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.programs.waybar;
in
{
  options.local.programs.waybar = with lib.types; {
    enable = lib.mkEnableOption "Waybar";

    package = lib.mkPackageOption pkgs "waybar" { };
    style = lib.mkOption {
      type = with lib.types; nullOr (either path lines);
      default = null;
    };

    settings = lib.mkOption {
      default = { };
      type = with lib.types; attrsOf anything;
    };
  };

  config = lib.mkIf cfg.enable {
    local.wrap.wraps."waybar" = {
      pkg = cfg.package;
      systemPackages = true;
      bins."waybar".envs."XDG_CONFIG_HOME".paths = {
        "waybar/config" = builtins.toJSON (builtins.attrValues cfg.settings);
        "waybar/style.css" = cfg.style;
      };
    };
    systemd.user.services.waybar = {
      partOf = [
        "graphical-session.target"
        "tray.target"
      ];
      after = [ "graphical-session.target" ];
      wantedBy = [
        "graphical-session.target"
        "tray.target"
      ];

      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";

      serviceConfig = {
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        ExecStart = lib.getExe config.local.wrap.wraps."waybar".finalPackage;
        KillMode = "mixed";
        Restart = "on-failure";
      };

    };
  };
}
