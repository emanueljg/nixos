{ config, pkgs, lib, ... }:

{
  systemd = let name = "loki-autobuilder"; in {
    timers.${name} = {
      wantedBy = [ "timers.target" ];
      after = [ "network-online.target" ];
      timerConfig = {
        OnCalendar="*-*-* *:*:00";
        Unit = "${name}.service";
      };
    };

    services.${name} = with pkgs; {
      path = [
        git
        nixos-rebuild
      ];
      script = ''
        git pull
        chown -R ejg:users /etc/nixos
        ${nixos-rebuild}/bin/nixos-rebuild --update-input app1-infrastruktur --update-input https-server-proxy --update-input nodehill-home-page --update-input devop22 --no-write-lock-file switch
      '';
      serviceConfig = {
        WorkingDirectory = "/etc/nixos";
      };
    };
  };
}
