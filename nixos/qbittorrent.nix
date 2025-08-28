{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.qbittorrent
  ];
}
