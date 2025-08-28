{
  pkgs,
  config,
  lib,
  ...
}:
let
  settings = {
    term = lib.getExe config.local.wrap.wraps."kitty".finalPackage;
    key_left = "h";
    key_down = "j";
    key_up = "k";
    key_right = "l";
  };

in
{
  local.wrap.wraps."wofi" = {
    pkg = pkgs.wofi;
    systemPackages = true;
    bins."wofi".envs."XDG_CONFIG_DIR".paths = {
      "wofi/config" = lib.generators.toKeyValue { } settings;
    };
  };
}
