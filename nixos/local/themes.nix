{ lib, ... }:
{
  options.local.themes = lib.mkOption {
    default = { };
    type = lib.types.attrsOf lib.types.anything;
  };
}
