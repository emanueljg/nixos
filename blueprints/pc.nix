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
    xwayland.opts
    wofi
    waybar.default

    # multimedia
    mpv
    ffmpeg
    ani-cli
    yt-dlp.default
    qbittorrent
    pipe-viewer.default

    # customization
    rice.darker.default
    xdg
    gtk.opts
    cursor.default
    fontconfig

    # programming
    nix-alien
  ];

  home = with home; [

  ];
}
