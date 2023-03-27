{ config, pkgs, lib, ... }:

{
  systemd = {
    requires = {

    services = {

    path = [ pkgs.colmena ];
      export 
    serviceConfig = {
      WorkingDirectory = "/etc/nixos";
    };

