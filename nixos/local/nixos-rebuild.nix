{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.nixos-rebuild;
in
{
  options.local.nixos-rebuild = {
    enable = lib.mkEnableOption "";
    baseKey = lib.mkOption {
      type = lib.types.str;
      default = "d";
    };
    hosts = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (
        lib.types.submodule (submod: {
          options = {
            enable = (lib.mkEnableOption "") // {
              default = true;
            };
            name = lib.mkOption {
              type = lib.types.str;
            };
            key = lib.mkOption {
              type = lib.types.str;
              default = "${cfg.baseKey}-${submod.config.name}";
            };
            cmd = lib.mkOption {
              type = lib.types.str;
            };
          };
        })
      );
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      let
        scripts = lib.pipe cfg.hosts [
          (builtins.filter (host: host.enable))
          (map (host: (pkgs.writeShellScriptBin host.key host.cmd)))
        ];
      in
      scripts
      ++ lib.optional (scripts != [ ]) (
        pkgs.writeShellScriptBin cfg.baseKey ((builtins.concatStringsSep " && " (map (s: s.name) scripts)))
      );
  };
}
