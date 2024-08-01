{ lib, packages, config, ... }:
let
  pkg = packages.deploy-rs;
in
{
  home.packages = [ pkg ];

  home.shellAliases."dep" =
    let
      deploy = lib.getExe pkg;
      flake = "${config.home.homeDirectory}/nixos";
    in
    "${deploy} path:${flake}";
}
