with (import ../../lib/funcs.nix); mkhost "crown" {
  blueprints = [ "core.nix" ];
  modules = [
    "hardware/efi-grub.nix"
    "programs/langs/python.nix"

    "services/porkbun-ddns.nix"
    "services/invidious.nix"
    "services/filmvisarna.nix"
  ];
}
