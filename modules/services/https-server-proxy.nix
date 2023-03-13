{ config, pkgs, https-server-proxy, ... }:

{
  environment.systemPackages = [
    pkgs.nodejs
    https-server-proxy.packages.${pkgs.system}.default
  ];
}
