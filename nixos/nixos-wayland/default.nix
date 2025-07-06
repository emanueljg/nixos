{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./greetd.nix
    ./pipewire.nix
  ];
  security.pam.services.swaylock = { };
  environment.systemPackages = [
    pkgs.wl-clipboard
  ];
}
