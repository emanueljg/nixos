{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./swaylock.nix
    ./wofi.nix
    ./waybar.nix
  ];
  environment.systemPackages = [
    pkgs.wl-clipboard
  ];
}
