{ self, pkgs, lib, config, options, ... }:
let
  cfg = config.local.wg;
  # TODO
  domain = "emanueljg.com";
  port = 51820;
  mkZone = n: "10.100.0.${builtins.toString n}";
in
{
  options.local.wg = {
    enable = lib.mkEnableOption "";
    this = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
    };
    interface = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "";
          server = {
            enable = lib.mkEnableOption "";
            externalInterface = lib.mkOption { type = lib.types.str; };
          };
          publicKey = lib.mkOption {
            type = lib.types.str;
          };
          n = lib.mkOption {
            type = lib.types.int;
          };
          peers = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
          };
        };
      });
      default = { };
    };
  };

  config =
    let
      thisCfg = cfg.hosts.${cfg.this};
    in

    lib.mkIf cfg.enable {
      networking.firewall.allowedUDPPorts = [ port ];

      sops.secrets."wg-private" = {
        sopsFile = "${self}/secrets/${cfg.this}/wireguard.yml";
        mode = "0440";
      };

      networking.nat = lib.mkIf thisCfg.server.enable {
        enable = true;
        inherit (thisCfg.server) externalInterface;
        internalInterfaces = [ cfg.interface ];
      };

      networking.wireguard = {
        enable = true;
        interfaces.${cfg.interface} =
          {
            ips = [ "${mkZone thisCfg.n}/24" ];
            listenPort = port;
            privateKeyFile = config.sops.secrets."wg-private".path;
            peers = map
              (peer:
                let peerCfg = cfg.hosts.${peer}; in {
                  inherit (peerCfg) publicKey;
                  persistentKeepalive = lib.mkIf (!peerCfg.server.enable) 25;
                  allowedIPs = [ (mkZone peerCfg.n) ];

                } // lib.optionalAttrs (peerCfg.server.enable) {
                  endpoint = "${domain}:${builtins.toString port}";
                  dynamicEndpointRefreshSeconds = 3600;
                })
              thisCfg.peers;
          } // lib.optionalAttrs thisCfg.server.enable {
            postSetup = ''
              ${lib.getExe' pkgs.iptables "iptables"} -t nat -A POSTROUTING -s ${mkZone 0}/24 -o ${thisCfg.server.externalInterface} -j MASQUERADE
            '';

            postShutdown = ''
              ${lib.getExe' pkgs.iptables "iptables"} -t nat -D POSTROUTING -s ${mkZone 0}/24 -o ${thisCfg.server.externalInterface} -j MASQUERADE
            '';
          };
      };
    };
}
