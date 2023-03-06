{ config, pkgs, ... }:

{
  my.home.packages = with pkgs; [
    jmtpfs
  ];
}
