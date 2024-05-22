{ pkgs, config, packages, lib, ... }: {

  programs.hyprland = {
    enable = true;
    package = packages.hyprland;
  };
}
