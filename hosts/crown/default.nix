with (import ../../lib/funcs.nix); mkhost "crown" {
  blueprints = [ "core.nix" ];
  modules = [
    "hardware/efi-grub.nix"
    "services/invidious.nix"
    "services/gitea.nix"
    "meta/wireguard/server.nix"
  ];
}
