{ config, pkgs, discordo, ... }:

{
  environment.systemPackages = [ discordo.defaultPackage.x86_64-linux ];
}
