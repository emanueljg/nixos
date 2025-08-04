{ pkgs, lib, ... }:
let
  settings = { };

in
{
  security.pam.services.swaylock = { };
  local.wrap.wraps."swaylock" = {
    pkg = pkgs.swaylock;
    systemPackages = true;
    bins."swaylock".envs."XDG_CONFIG_HOME".paths = {
      "swaylock/config" = lib.pipe settings [
        (lib.filterAttrs (n: v: v != false))
        (builtins.mapAttrs (n: v: if v == true then n else "${n}=${v}"))
        (builtins.attrValues)
        (builtins.concatStringsSep "\n")
      ];
    };
  };
}
