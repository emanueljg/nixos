{ config, pkgs, lib, ... }:

{
  my.home.shellAliases = {
    "col" = "colmena --config=/etc/nixos/flake.nix";
    "cola" = "col apply";
    "coll" = "col apply-local --sudo";
  };

  environment.systemPackages = with pkgs; [
    (colmena.overrideAttrs (oldAttrs: rec {
      version = "0.4.0pre";
      src = fetchFromGitHub {
        owner = "zhaofengli";
        repo = "colmena";
        rev = "main";
        sha256 = "sha256-XcmirehPIcZGS7PzkS3WvAYQ9GBlBvCxYToIOIV2PVE=";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs(_: {
        inherit src;
        outputHash = "sha256-U9vxDogjESNRrDqDGC27qfRyGLkmDWQ1gNxqAehUfwk=";
      });
    }))
  ];
}
