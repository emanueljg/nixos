{ config, pkgs, lib, ... }: {
  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
  };

  services.greetd = {
    enable = true;
    package = pkgs.greetd.tuigreet;
    vt = 2;
  };

  systemd.services.greetd.serviceConfig.ExecStart =
    let
      cmd = lib.getExe config.services.greetd.package;
      flags = lib.cli.toGNUCommandLineShell { } {
        time = true;
        remember = true;
        remember-user-session = true;
        asterisks = true;
        user-menu = true;
        cmd = "Hyprland";
        width = 100;
        greeting = ''
          En vanlig bågskytt övar tills han gör rätt 
            -- en spejare övar tills han aldrig gör fel.
        '';
      };

    in
    lib.mkForce "${cmd} ${flags}";

}
