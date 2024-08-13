{ inputs, home, nixos, blueprints, ... }: {

  parents = [
    blueprints.base
  ];

  nixos = with nixos; [
  ];

  home = with home; [
    langs.default
    term.default
    ./hm.nix
  ];
}
