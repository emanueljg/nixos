{ hosts, blueprints, nixos, home, ... }: {
  parents = [ blueprints.opts ];
  nixos = with nixos; [
    hw
    enable-flakes
    garnix
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
