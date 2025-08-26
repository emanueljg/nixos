{ other, lib, ... }: {
  environment.systemPackages =
    builtins.attrValues (lib.removeAttrs other.vidya [ "utils" "zzz" ]);
}
