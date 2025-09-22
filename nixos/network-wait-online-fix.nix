{ lib, ... }:
{
  # https://github.com/NixOS/nixpkgs/issues/405109
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
}
