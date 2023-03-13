with (import ../lib/funcs.nix); mkhost "void" {
  blueprints = [ "pc.nix" ];
  modules = [
    "meta/efi-grub.nix"
    "services/ssh/mothership.nix"

    # vidya 
    "programs/x/nvidia.nix"
    "programs/x/eosd.nix"
  ];
}
