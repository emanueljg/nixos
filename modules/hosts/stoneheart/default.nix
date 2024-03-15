_: {
  imports = [
    ../../pc

    ../../uses-nvidia.nix

    ./configuration.nix
    ./force-nvidia-pipeline.nix
    ./disko.nix
    ./screens.nix
    ./nginx.nix
  ];
}
