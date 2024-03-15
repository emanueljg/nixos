_: {

  imports = [
    ../../base
    ./wsl.nix
  ];

  my.home.stateVersion = "23.11";
  system.stateVersion = "23.11";
  networking.hostName = "weasel";
}
