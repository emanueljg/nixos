{ pkgs, lib, ... }:
let
  settings = { };

in
{
  security.pam.services.swaylock = { };
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "swaylock";
      paths = [ pkgs.swaylock ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/swaylock \
          --set 'XDG_CONFIG_DIR' ${
            pkgs.symlinkJoin {
              name = "swaylock-confdir";
              paths = [(
                pkgs.writeTextDir "swaylock/config" (
                  lib.pipe settings [
                    (lib.filterAttrs (n: v: v != false))
                    (builtins.mapAttrs (n: v: if v == true then n else "${n}=${v}"))
                    (builtins.attrValues)
                    (builtins.concatStringsSep "\n")
                  ]
                )
              )];
            }
          }
      '';
    })
  ];
}
