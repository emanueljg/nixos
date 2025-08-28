{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.tor-browser
  ];
}
