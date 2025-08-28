{ pkgs, ... }:
{
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  environment.systemPackages = [
    pkgs.mangohud
  ];
}
