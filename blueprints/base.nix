{ hosts, blueprints, nixos, home, ... }: {
  parents = [ blueprints.opts ];
  nixos = with nixos; [
    enable-flakes
    garnix
    pkgs
    openssh-server
    swedish-locale
    user
    sops
    { custom.efi-grub.enable = true; }
  ];
  home = with home; [
    term.default
    colmena
    openssh-client
  ];
}  
