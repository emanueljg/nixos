{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.wl-clipboard
  ];
}
