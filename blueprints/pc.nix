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
  ];

  home = with home; [
    qutebrowser.default
    rice.darker.default
    cursor
    gtk

    go
    nodejs
    python
    rust

    mime
    wayland.default
    fontconfig
    newsboat
    pyradio

  ];
}
