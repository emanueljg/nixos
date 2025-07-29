{ pkgs, lib, config, ... }:
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

    systemd.user.services.hyprpaper = {
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";

      serviceConfig = {
        ExecStart = lib.getExe (
          pkgs.symlinkJoin {
            name = "hyprpaper-confed";
            paths = [
              cfg.package
            ];
            inherit (cfg.package) meta;
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/hyprpaper \
                --set 'XDG_CONFIG_HOME' ${
                  pkgs.writeTextDir "hypr/hyprpaper.conf" (config.local.lib.toHyprConf { attrs = cfg.settings; })
                }
            '';
          }
        );
        Restart = "always";
        RestartSec = "10";
      };
    };

  };
}
