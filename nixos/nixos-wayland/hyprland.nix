{ hyprland, pkgs, config, lib, ... }: {

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };
}
