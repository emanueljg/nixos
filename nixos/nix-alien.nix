{ lib, packages, ... }:
{
  programs.nix-ld.enable = true;
  environment.systemPackages = [ packages.nix-alien ];
}
