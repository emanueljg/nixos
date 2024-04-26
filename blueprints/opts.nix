{ hosts, blueprints, nixos, home, ... }: {
  parents = [ ];
  nixos = with nixos; [
    efi-grub-opt
    nvidia-opt
    hibernation-opt
    stay-awake-opt
  ];
  home = with home; [
  ];
}  
