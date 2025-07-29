{ config, inputs, home, nixos, blueprints, inputs', ... }: {

  imports = [
    blueprints.base
  ];

  specialArgs = {
    nixpkgs = {
      inherit (inputs) nixos-unstable;
    };
    packages = {
      inherit (inputs'.nix-alien.packages) nix-alien;
    };
  };


  nixos = with nixos; [
    # core
    networkmanager
    pavucontrol
    hw.bluetooth
    add-headphones-script

    # general software
    firefox
    qutebrowser.default
    tor-browser

    # wayland
    hyprland.default
    greetd
    swaylock
    pipewire
    wl-clipboard
    wofi
    waybar

    # multimedia
    mpv
    ffmpeg
    ani-cli
    yt-dlp
    qbittorrent
    pipe-viewer.default

    # customization
    rice.darker.default
    xdg
    cursor
    fontconfig

    # programming
    nix-alien
  ];

  home = with home; [

  ];
}
