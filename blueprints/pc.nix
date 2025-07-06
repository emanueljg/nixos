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
  ];

  home = with home; [
    firefox
    qutebrowser.default
    rice.darker.default
    cursor
    gtk

    go
    nodejs
    python
    rust

    add-headphones-script
    pass-secret-service

    mime
    wayland.default
    fontconfig
    pavucontrol
    yt-dlp
    newsboat
    pyradio
    ani-cli

  ];
}
