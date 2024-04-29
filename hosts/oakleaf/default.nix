{ home, nixos, blueprints, ... }: {

  parents = [
    blueprints.pc
  ];

  home = with home; [
    wayland.default
    ./hm.nix
    ./vccvpn.nix
    ./nixGL.nix
  ];

  nixos = [ ];

}
