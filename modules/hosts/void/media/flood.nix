{ config, pkgs, lib, ... }:
let
  cfg = config.services.flood;
in
with lib; {
  options.services.flood = {

    enable = mkEnableOption "Flood torrent monitoring service";

    package = mkPackageOption pkgs "flood" { };

    user = mkOption {
      type = types.str;
      default = "flood";
      description = lib.mdDoc ''
        User account under which flood runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "flood";
      description = lib.mdDoc ''
        Group under which flood runs.
      '';
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };

    port = mkOption {
      type = types.port;
      default = 3000;
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/flood";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
    };

    auth = mkOption {
      default = { default.enable = true; }; # enable default authentication by default
      type = types.submodule {
        options = {
          default = mkOption {
            default = { };
            type = types.submodule {
              options = {
                enable = mkEnableOption "default authentication";
              };
            };
          };
          deluge = mkOption {
            default = { };
            type = types.submodule {
              options = {
                enable = mkEnableOption "deluge authentication";
                host = mkOption {
                  type = types.str;
                };
                port = mkOption {
                  type = types.port;
                };
                username = mkOption {
                  type = types.str;
                };
                passwordFile = mkOption {
                  type = types.str;
                };
              };
            };
          };
          rtorrent = mkOption {
            default = { };
            description = mdDoc ''
              Authentication settings for rtorrent.

              If set as NixOS-managed rtorrent (see `fromNixOS`), defaults to socket authentication.
              If not, authentication method must be set manually.
            '';
            type = types.submodule {
              options = {
                enable = mkEnableOption "rtorrent authentication";
                fromNixOS = mkOption {
                  type = types.bool;
                  default = false;
                  description = ''
                    Whether to assume this rtorrent daemon to be managed by NixOS at `config.services.rtorrent` 
                    or not. 

                    This is a QoL option that sets some nice defaults, like rtorrent socket configuration.
                    With this enabled, connecting to rtorrent with flood can be as simple as:
                    ```
                    services.rtorrent = {
                      enable = true;
                      openFirewall = true;
                    };
                    services.flood = {
                      enable = true;
                      openFirewall = true;
                      auth.rtorrent = {
                        enable = true;
                        fromNixOS = true;
                      };
                    };
                    ```
                  '';
                };
                host = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                port = mkOption {
                  type = types.nullOr types.port;
                  default = null;
                };
                socket = mkOption {
                  type = types.nullOr types.str;
                  default = if cfg.auth.rtorrent.fromNixOS then config.services.rtorrent.rpcSocket else null;
                };
              };
            };
          };
          qbittorrent = mkOption {
            default = { };
            type = types.submodule {
              options = {
                enable = mkEnableOption "qbittorrent authentication";
                url = mkOption {
                  type = types.str;
                };
                username = mkOption {
                  type = types.str;
                };
                passwordFile = mkOption {
                  type = types.str;
                };
              };
            };
          };
          transmission = mkOption {
            default = { };
            type = types.submodule {
              options = {
                enable = mkEnableOption "transmission authentication";
                url = mkOption {
                  type = types.str;
                };
                username = mkOption {
                  type = types.str;
                };
                passwordFile = mkOption {
                  type = types.str;
                };
              };
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    users.groups = mkIf (cfg.group == "flood") {
      flood = { };
      ${config.services.rtorrent.group}.members = mkIf (cfg.auth.rtorrent.fromNixOS && cfg.auth.rtorrent.enable) [ cfg.user ];
    };

    users.users = mkIf (cfg.user == "flood") {
      flood = {
        inherit (cfg) group;
        shell = pkgs.bashInteractive;
        home = cfg.dataDir;
        description = "flood Daemon user";
        isSystemUser = true;
      };
    };


    assertions =
      let
        floodCfg = "config.services.flood";
        authPath = "${floodCfg}.auth";
        enabledAuths = attrNames (filterAttrs (_: v: v.enable) cfg.auth);
        xor = bool1: bool2: (bool1 || bool2) && !(bool1 && bool2);

        baseMessage = "Flood (${floodCfg}) assertion failed!:";

        authTypeMessage = ''
          ${baseMessage}
          Exactly ONE (1) Flood authentication type must be enabled!";
        '';
      in
      [
        {
          assertion = (length enabledAuths) != 0;
          message = ''
            ${authTypeMessage}
            You have 0 Flood authentication types enabled.
            Please enable at least one in ${authPath}, 
            or disable Flood.
          '';
        }
        {
          assertion = !((length enabledAuths) > 1);
          message = ''
            ${authTypeMessage}
            Enabled authentication types:
            ${concatMapStringsSep "\n" (authType: "  - ${authPath}.${authType}.enable = true;") enabledAuths} 
          '';
        }
        {
          assertion = (cfg.auth.rtorrent.enable && cfg.auth.rtorrent.fromNixOS) -> config.services.rtorrent.enable;
          message = ''
            ${baseMessage}
            Authentication type set to NixOS-managed rtorrent but config.services.rtorrent isn't enabled!
          '';
        }
        {
          assertion = cfg.auth.rtorrent.enable -> (
            xor
              (cfg.auth.rtorrent.host != null && cfg.auth.rtorrent.port != null)
              (cfg.auth.rtorrent.socket != null)
          );
          message = ''
            ${baseMessage}
            Exactly ONE (1) of rtorrent's auth methods (host & port OR socket) must be enabled.
          '';
        }
      ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.flood = {
      description = "Flood torrent monitoring service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      environment.HOME = "/dev/null";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart =
          let
            floodOptions = attrsets.mergeAttrsList [
              {
                inherit (cfg) host port;
                rundir = cfg.dataDir;
                auth = if cfg.auth.default.enable then "default" else "none";
              }
              (optionalAttrs cfg.auth.deluge.enable {
                dehost = cfg.auth.deluge.host;
                deport = cfg.auth.deluge.port;
                deuser = cfg.auth.deluge.username;
                depass = "$(cat ${cfg.auth.deluge.passwordFile})";
              })
              (optionalAttrs cfg.auth.rtorrent.enable {
                rthost = cfg.auth.rtorrent.host;
                rtport = cfg.auth.rtorrent.port;
                rtsocket = cfg.auth.rtorrent.socket;
              })
              (optionalAttrs cfg.auth.qbittorrent.enable {
                qburl = cfg.auth.qbittorrent.url;
                qbuser = cfg.auth.qbittorrent.username;
                qbpass = "$(cat ${cfg.auth.qbittorrent.passwordFile})";
              })
              (optionalAttrs cfg.auth.transmission.enable {
                trurl = cfg.auth.transmission.url;
                truser = cfg.auth.transmission.username;
                trpass = "$(cat ${cfg.auth.transmission.passwordFile})";
              })
            ];
          in
          ''
            ${lib.getExe cfg.package} ${cli.toGNUCommandLineShell {} floodOptions}
          '';
        WorkingDirectory = cfg.dataDir;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectHostname = true;
      };
    };
  };

}

