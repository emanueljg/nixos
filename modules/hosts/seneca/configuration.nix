_: {
  imports = [
    ./hardware_configuration.nix
  ];

  networking.hostName = "seneca";

  system.stateVersion = "22.05";
  my.home.stateVersion = "22.05";
}
