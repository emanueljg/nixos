{ config
, pkgs
, lib
, self
, ...
}:
let
  service = "porkbun-ddns";
  user = "root";
  User = user;
  owner = user;
  group = "root";
  Group = group;

  secret = service;
in
{
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
    sopsFile = "${self}/secrets/${config.networking.hostName}/${secret}.yml";
    mode = "0440";
    inherit owner group;
  };

  systemd = {
    timers.${service} = {
      wantedBy = [ "timers.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      timerConfig = {
        OnBootSec = "10";
        OnUnitActiveSec = "1h";
        Unit = "${service}.service";
      };
    };

    services.${service} =
      let
        domain = "emanueljg.com";
        skPath = config.sops.secrets.${secret}.path;
        pk = "pk1_78185aaeb4231ae38f608c4d8c2eceeb7219c79bfff11727b1e32701915f8944";
        endpoint = "https://porkbun.com/api/json/v3/dns/editByNameType/${domain}/A";
        porkbun-json = pkgs.writeTextFile {
          name = "porkbun-json-details";
          # not using builtins.toJSON because it's not valid json; it has args for jq in it.
          text = ''
            { 
              "secretapikey": $secretapikey,
              "apikey": "${pk}",
              "content": $current_ip
            }
          '';
        };

        cmd = pkgs.writeShellApplication {
          name = "update-porkbun-ip";
          runtimeInputs = [ pkgs.curl pkgs.dig pkgs.jq ];
          text = ''
            CURRENT_IP="$(curl -s ifconfig.me)"
            PORKBUN_IP="$(dig +short www.${domain})"
            if [ "$CURRENT_IP" != "$PORKBUN_IP" ]; then
              curl \
                -X 'POST' \
                --json "$(jq \
                  --null-input \
                  --arg 'secretapikey' "$(cat ${skPath})" \
                  --arg 'current_ip' "$CURRENT_IP" \
                  "$(cat ${porkbun-json})")" \
                '${endpoint}'
              else
                echo 'IP has not changed, doing nothing.'
                exit 0
            fi
          '';
        };
      in
      {
        serviceConfig = {
          Type = "oneshot";
          inherit User Group;
          ExecStart = lib.getExe cmd;
        };
      };
  };
}

