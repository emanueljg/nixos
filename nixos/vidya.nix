{ other, lib, pkgs, ... }: {
  local.allowed-unfree.names = [ "katawa-shoujo" ];
  environment.systemPackages =
    (builtins.attrValues (lib.removeAttrs other.vidya [ "utils" "zzz" ]))
    ++ [ pkgs.katawa-shoujo ];
}
