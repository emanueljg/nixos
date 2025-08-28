{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.local.programs.yt-dlp;

in
{
  options.local.programs.yt-dlp = {
    enable = lib.mkEnableOption "bleb";
    package = lib.mkPackageOption pkgs "yt-dlp" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
