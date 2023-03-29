{ config, pkgs, lib, ... }:

{
  systemd = let name = "loki-autobuilder"; in {
 #   timers.${name} = {
 #     wantedBy = [ "timers.target" ];
 #     after = [ "network-online.target" ];
 #     timerConfig = {
 #       OnCalendar="*-*-* *:*:00";
 #       Unit = "${name}.service";
 #     };
 #   };

    services.${name} = let
      colmena = (
        lib.lists.findFirst
          (pkg: pkg.name == "colmena-0.4.0pre")
          "notfound"
          config.environment.systemPackages
      );
      git = pkgs.git;
      nix = pkgs.nix;
      openssh = pkgs.openssh;
    in {
      path = [
        git
        colmena
        nix
        openssh
      ];
      environment = {
        inherit (config.home-manager.users.ejg.home.sessionVariables) SSH_CONFIG_FILE;
      };
      script = ''
        ${git}/bin/git pull
        ${nix}/bin/nix flake lock --update-input app1-infrastruktur --update-input https-server-proxy --update-input nodehill-home-page --update-input devop22
        ${colmena}/bin/colmena apply --config=/etc/nixos/flake.nix --on=loki --show-trace
      '';
      serviceConfig = {
        User = "ejg";
        WorkingDirectory = "/etc/nixos";
      };
    };
  };
}
