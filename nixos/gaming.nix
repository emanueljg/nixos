{ pkgs, ... }: {
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
    lutris
  ];
}
