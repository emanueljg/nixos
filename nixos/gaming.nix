{ pkgs, ... }: {
  programs.steam.enable = true;
  virtualisation.waydroid.enable = true;
  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
    lutris
  ];
}
