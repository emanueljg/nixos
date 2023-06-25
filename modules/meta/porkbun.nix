{ config, pkgs, lib, ... }: let

hosts = import ../../hosts.nix;
hostname = config.networking.hostName;
inherit (import ../../_common.nix) domain;
apikey = "pk1_78185aaeb4231ae38f608c4d8c2eceeb7219c79bfff11727b1e32701915f8944";
service = "porkbun-ddns";
secret = service;
in lib.mkIf (hostname != "fenix") {

  sops.secrets.${secret} = {
    sopsFile = ../../secrets/${secret}.yaml;
    mode = "0440";
  };

  systemd = {

    timers.${service} = {
      # wantedBy = [ "timers.target" ];
      # after = [ "network-online.target" ];
      timerConfig = {
        AccuracySec = "1sec";
        OnCalendar = ":*:0/10";
        Unit = "${service}.service";
      };
    };

    services.${service} = {
      path = [ pkgs.curl pkgs.jq ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = let
          pkeyPath = config.sops.secrets.${secret}.path;
          target = hosts.${hostname}.endpoint;
          endpoint = "https://porkbun.com/api/json/v3/dns/editByNameType/" + 
            builtins.concatStringsSep "/" [ domain "a" hostname ]; 
        in ''
          set -e
          
          CURRENT_IP=$(curl ifconfig.me)
          PORKBUN_IP=$(dig +short ${target})
          if [ $CURRENT_IP != $PORKBUN_IP ]; then
          curl -X POST ${endpoint} \
            -H 'Content-Type: application/json' \
            -d '{"secretapikey": "$(cat ${pkeyPath})",'`
               `'"apikey": "${apikey}",'`
               `'"content": "$CURRENT_IP"}' 
        '';
      };
    };
  };
}
