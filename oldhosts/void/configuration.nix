_: {

  imports = [
    ./hardware_configuration.nix
  ];

  networking.hostName = "void";
  system.stateVersion = "22.11";
}
