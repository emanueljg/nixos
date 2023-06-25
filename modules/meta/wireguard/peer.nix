{ config, lib, ... }: 

let 

  listenPort = 51820;
  wg-network = "wg0";
  privateKeyFile = "/root/wireguard-keys/private";
  endpoint = "emanueljg.com:${listenPort}";

  hosts = import ../../../hosts.nix;
  host = hosts.${config.networking.hostName};

in {
  networking.firewall.allowedUDPPorts = [ listenPort ];

  networking.wireguard.interfaces.${wg-network} = {
    ips = [ "${host.ip}/24" ];
    inherit listenPort privateKeyFile;

    peers = lib.attrsets.mapAttrsToList (name: value: {
      inherit (value) publicKey;
      allowedIPs = [ "${value.ip}/32" ];

      endpoint = lib.mkIf 
        (value.endpoint != null) 
        "${value.endpoint}:${listenPort}";

      persistentKeepalive = 25;
    }) hosts;
  };
}

