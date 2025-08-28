{ config, lib, ... }:
{
  options.local.lan = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
  };
}
