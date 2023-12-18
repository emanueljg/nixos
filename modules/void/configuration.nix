{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "void";
  system.stateVersion = "22.11";
  my.home.stateVersion = "22.11";

  my.home.packages = with pkgs; [
    steam-run
  ];
}
