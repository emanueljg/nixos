with (import ../../lib/funcs.nix); mkhost "void" {
  blueprints = [ "pc.nix" ];
  modules = [
    "hardware/efi-grub.nix"
    "hardware/hibernation.nix"

    "services/ssh/mothership.nix"

    "services/navidrome.nix"

    "programs/x/firefox.nix"

    # vidya 
    "programs/x/nvidia.nix"
  ];
}
