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
        colmena
        nix
      ];
      script = ''
        ${git}/bin/git pull
        ${nix}/bin/nix flake lock --update-input app1-infrastruktur --update-input https-server-proxy --update-input nodehill-home-page --update-input devop22
        ${colmena}/bin/colmena apply --on=loki 
      '';
      serviceConfig = {
        User = "ejg";
        WorkingDirectory = "/etc/nixos";
      };
    };
  };
}
