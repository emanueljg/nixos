{ config, inputs, home, nixos, blueprints, inputs', ... }: {

  imports = [
    blueprints.base
  ];

  specialArgs = {
    nixpkgs = {
      inherit (inputs) nixos-unstable;
    };
  };


  nixos = with nixos; [
    networkmanager
    hw.bluetooth
    fetch-from-itch
    rice.darker.default
    mpv
    firefox
    add-headphones-script
    ani-cli
    yt-dlp
    pavucontrol
    tor-browser
    qbittorrent
    qutebrowser.default

    nixos-wayland.default

    swaylock
    wofi
    waybar.default

    xdg
  ];

  home = with home; [
    rice.darker.default
    cursor
    gtk

    wayland.hyprland
    fontconfig
  ];
}
