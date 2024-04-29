{ home, nixos, blueprints, ... }: {

  parents = [
    blueprints.pc
    { boot.isContainer = true; }
  ];

  home = with home; [
    wayland.default
    ./hm.nix
    ./vccvpn.nix
    ./nixGL.nix
  ];

  nixos = [ ];

}
