_: {
  imports = [
    ./hyprland.nix
    ./greetd.nix
    ./pipewire.nix
  ];
  security.pam.services.swaylock = { };
}
