with (import ../../lib/funcs.nix); mkhost "seneca" {
  blueprints = [ "pc.nix" ];
  modules = [
    "hardware/efi-grub.nix"
    "hardware/hibernation.nix"
    "hardware/stay-awake.nix"

    "services/https-server-proxy.nix"
  ];
}
