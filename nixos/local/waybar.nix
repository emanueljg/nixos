{ config, pkgs, lib, ... }:
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

  config =
    let
      pkg =
        (pkgs.symlinkJoin {
          name = "waybar-confed";
          paths = [ cfg.package ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          inherit (cfg.package) meta;
          postBuild = ''
            wrapProgram $out/bin/waybar \
              --set 'XDG_CONFIG_HOME' ${
                pkgs.symlinkJoin {
                  name = "waybar-confdir";
                  paths = [
                    (pkgs.writeTextDir "waybar/config" (builtins.toJSON (builtins.attrValues cfg.settings)))
                  ] ++ lib.optional (cfg.style != null) (
                    if builtins.isPath cfg.style then
                      pkgs.runCommand "waybar-style.css" { } ''
                        mkdir -p $out/waybar
                        cp ${cfg.style} $out/waybar/style.css
                      ''
                     else
                        pkgs.writeTextDir "waybar/style.css" cfg.style
                    );
                }
              }
          '';
        });
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ pkg ];
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
          ExecStart = lib.getExe pkg;
          KillMode = "mixed";
          Restart = "on-failure";
        };

      };
    };
}

