{ hosts, blueprints, nixos, home, ... }: {
  parents = [ ];
  nixos = with nixos; [
    hw
    efi-grub
    enable-flakes
    garnix
    nvidia
    opengl
    pkgs
    ssh
    swedish-locale
    user
  ];
  home = with home; [
    term.default
    colmena
    openssh-client
  ];
}  
