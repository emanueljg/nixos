{ pkgs, lib, ... }:
let
  vintagestory = (import
    (builtins.fetchTarball {
      url = "https://github.com/js6pak/nixpkgs/archive/4196e2ce85413d7f21a7ac932bfcf0ad70d2ef01.tar.gz";
      sha256 = "sha256:1r2mp8yi6dsipyy0ialv89pxq3qv29skjl1ib4abcl7237xqsprk";
    })
    {
      inherit (pkgs) system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "dotnet-runtime-7.0.20" ];
      };
    }).vintagestory;

  nvidiaVintagestory = pkgs.writeShellApplication {
    name = "vs";
    runtimeInputs = [
      vintagestory
    ];
    text = ''
      nvidia-offload vintagestory "$@"
    '';
  };
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vintagestory"
  ];
  environment.systemPackages = [
    nvidiaVintagestory
    vintagestory
  ];
}
