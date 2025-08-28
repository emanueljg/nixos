{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.local.programs.xwayland;
in
{
  options.local.programs.xwayland = {
    enable = lib.mkEnableOption "";
    package = lib.mkPackageOption pkgs "xwayland" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
