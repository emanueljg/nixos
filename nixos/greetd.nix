{
  config,
  pkgs,
  lib,
  ...
}:
{
  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = [ pkgs.terminus_font ];
  };

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session =
      let
        exe = lib.getExe pkgs.tuigreet;
        flags = lib.cli.toGNUCommandLineShell { } {
          time = true;
          remember = true;
          remember-user-session = true;
          asterisks = true;
          user-menu = true;
          cmd = "Hyprland";
        };
      in
      {
        command = "${exe} ${flags}";
      };
  };

}
