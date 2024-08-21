{ pkgs, ... }: {
  programs.steam.enable = true;
  virtualisation.waydroid.enable = true;
  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
    lutris
    (pkgs.writeShellApplication {
      name = "blue-archive";
      text = "waydroid app launch com.nexon.bluearchive";
    })
  ];
}
