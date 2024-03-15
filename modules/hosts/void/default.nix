_: {
  imports = [
    ../../base

    ../../uses-nvidia.nix

    ./configuration.nix

    ./media

    ./nginx.nix
    ./porkbun.nix
  ];
}
