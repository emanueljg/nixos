{ inputs, home, nixos, blueprints, ... }: {

  parents = [
    blueprints.base
  ];

  nixos = with nixos; [
    { boot.isContainer = true; }
  ];

  home = with home; [
    langs.default
    term.default
    ./hm.nix
  ];
}
