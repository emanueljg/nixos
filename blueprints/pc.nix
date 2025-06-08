{ config, inputs, home, nixos, blueprints, inputs', ... }: {

  imports = [
    blueprints.base
  ];

  specialArgs = {
    nixpkgs = {
      inherit (inputs) nixos-unstable;
    };
    other = {
      nixpkgs-unfree = import config.specialArgs.nixpkgs {
        inherit (config) system;
        config.allowUnfree = true;
      };
    };

  };


  nixos = with nixos; [
    networkmanager
    hw.bluetooth
  ];

  home = with home; [
    firefox
    qutebrowser.default
    rice.darker.default
    gamescope
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
    pkgs
    fontconfig
    pavucontrol
    yt-dlp
    newsboat
    pyradio
    ani-cli

  ];
}
