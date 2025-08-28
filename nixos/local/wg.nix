{
  self,
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.local.wg;
  # TODO
  domain = "emanueljg.com";
  port = 51820;
  mkZone = n: "10.100.0.${builtins.toString n}";
  mkHostType =
    { readOnlyIP }:
    lib.types.submodule (submod: {
      options = {
        enable = lib.mkEnableOption "";
        server = {
          enable = lib.mkEnableOption "";
          externalInterface = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
          };
        };
        publicKey = lib.mkOption {
          type = lib.types.str;
        };
        n = lib.mkOption {
          type = lib.types.int;
        };
        ip = lib.mkOption {
          type = lib.types.str;
          readOnly = readOnlyIP;
          default = mkZone submod.config.n;
        };
        peers = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
        };
      };
    });
in
{
  options.local.wg = {
    enable = lib.mkEnableOption "";
    interface = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };
    hosts = lib.mkOption {
      type = lib.types.attrsOf (mkHostType {
        readOnlyIP = true;
      });
      default = { };
    };
    this = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
    };
    thisCfg = lib.mkOption {
      # cfg.hosts.<name>.ip gets "set" two times internally due to
      # thisCfg, so that's why this type has to
      # set it as writeable. But this thisCfg type itself is readOnly,
      # so there's no "security compromise".
      type = mkHostType { readOnlyIP = false; };
      readOnly = true;
      default = cfg.hosts.${cfg.this};
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ port ];

    sops.secrets."wg-private" = {
      sopsFile = "${self}/secrets/${cfg.this}/wireguard.yml";
      mode = "0440";
    };

    networking.nat = lib.mkIf cfg.thisCfg.server.enable {
      enable = true;
      inherit (cfg.thisCfg.server) externalInterface;
      internalInterfaces = [ cfg.interface ];
    };

    networking.wireguard = {
      enable = true;
      interfaces.${cfg.interface} = {
        ips = [ "${cfg.thisCfg.ip}/24" ];
        listenPort = port;
        privateKeyFile = config.sops.secrets."wg-private".path;
        peers = map (
          peer:
          let
            peerCfg = cfg.hosts.${peer};
          in
          {
            inherit (peerCfg) publicKey;
            persistentKeepalive = lib.mkIf (!peerCfg.server.enable) 25;
            allowedIPs = [ (peerCfg.ip) ];

          }
          // lib.optionalAttrs (peerCfg.server.enable) {
            endpoint = "${domain}:${builtins.toString port}";
            dynamicEndpointRefreshSeconds = 3600;
          }
        ) cfg.thisCfg.peers;
      }
      // lib.optionalAttrs cfg.thisCfg.server.enable {
        postSetup = ''
          ${lib.getExe' pkgs.iptables "iptables"} -t nat -A POSTROUTING -s ${mkZone 0}/24 -o ${cfg.thisCfg.server.externalInterface} -j MASQUERADE
        '';

        postShutdown = ''
          ${lib.getExe' pkgs.iptables "iptables"} -t nat -D POSTROUTING -s ${mkZone 0}/24 -o ${cfg.thisCfg.server.externalInterface} -j MASQUERADE
        '';
      };
    };
  };
}
