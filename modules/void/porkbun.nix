{ config, pkgs, lib, ... }: let

service = "porkbun-ddns";
user = "root"; User = user; owner = user;
group = "root"; Group = group;

secret = service;

in {

   users.groups = lib.mkIf (group == service) {
     ${service} = { };
   };

   users.users = lib.mkIf (user == service) {
     ${service} = {
       inherit group;
       description = "${service} daemon user";
       isSystemUser = true;
     };
   };

  sops.secrets.${secret} = {
    sopsFile = ../../secrets/${secret}.yaml;
    mode = "0440";
    inherit owner group;
  };

  systemd = {

    timers.${service} = {
      wantedBy = [ "timers.target" ];
      after = [ "network-online.target" ];
      timerConfig = {
        OnBootSec = "10";
        OnUnitActiveSec = "1h";
        Unit = "${service}.service";
      };
    };

    services.${service} = let
      domain = "emanueljg.com";
      skPath = config.sops.secrets.${secret}.path;
      pk = "pk1_78185aaeb4231ae38f608c4d8c2eceeb7219c79bfff11727b1e32701915f8944";
      endpoint = "https://porkbun.com/api/json/v3/dns/editByNameType/${domain}/a/*"; 
      cmd = pkgs.writeShellScriptBin service ''
        set -e
        
        CURRENT_IP="$(curl -s ifconfig.me)"
        PORKBUN_IP="$(dig +short ${domain})"
        if [ "$CURRENT_IP" != "$PORKBUN_IP" ]; then
          curl -X POST ${endpoint} \
            -H 'Content-Type: application/json' \
            -d '{"secretapikey": '"\"$(cat ${skPath})\""','`
               `'"apikey": "${pk}",'`
               `'"content": '"\"$CURRENT_IP\""'}' 
        fi
        '';
    in {
      path = with pkgs; [ curl dig ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${cmd}/bin/${service}";
        inherit User Group;
      };
    };
  };
}
