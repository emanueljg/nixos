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
    ffmpeg
    pipe-viewer.default
    rice.darker.default

    xwayland.opts
    hyprland.default

    gtk.opts
    fontconfig
    cursor.default
  ];

  home = with home; [

  ];
}
