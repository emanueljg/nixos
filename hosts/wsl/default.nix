{ inputs, home, nixos, blueprints, ... }: {

  parents = [
    blueprints.base
  ];

  home = with home; [
    langs.default
    term.default
    ./hm.nix
  ];
}
