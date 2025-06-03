{ inputs, home, nixos, blueprints, inputs', ... }: {

  imports = [
    blueprints.base
  ];

  specialArgs = {
    nixpkgs = {
      inherit (inputs) nixos-unstable;
    };

    packages = {
      discordo = inputs'.discordo.packages.discordo;
    };

    homeModules = {
      inherit (inputs.discordo.homeModules) discordo;
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
    discordo
    yt-dlp
    newsboat
    pyradio
    ani-cli

  ];
}
