{ config, pkgs, lib, ... }:
{
  options.local.packages = lib.mkOption {
    default = { };
    type = with lib.types; attrsOf package;
  };

  config = {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "bld" ''
        nix build .#${config.networking.hostName}."$@"
      '')
      (pkgs.writeShellScriptBin "evl" ''
        nix eval .#${config.networking.hostName}."$@"
      '')
    ];
  };

}
  
