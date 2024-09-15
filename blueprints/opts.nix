{ hosts, blueprints, nixos, home, ... }: {
  parents = [ ];
  nixos = with nixos; [
    hw.efi-grub-opt
    hw.nvidia-opt
    hw.hibernation-opt
    hw.stay-awake-opt
    # flood-opt
  ];
  home = with home; [
    pyradio-opt
    qutebrowser.stylesheets-opt
  ];
}  
