{ lib, ... }:
{
  programs.steam.enable = true;
  local.allowed-unfree.names = [
    "steam"
    "steam-unwrapped"
  ];
}
