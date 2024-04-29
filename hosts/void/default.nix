{ blueprints, hosts, home, nixos, ... }: {
  parents = with blueprints; [
    base
  ];
  nixos = with nixos; [
    hw.nvidia

    ./configuration.nix

    ./media

    ./nginx.nix
    ./porkbun.nix
  ];
  home = with home; [
    ./hm.nix
  ];
}
