{ inputs, home, nixos, blueprints, inputs', ... }: {

  imports = [
    blueprints.base
  ];

  specialArgs = {
    nixpkgs = {
      inherit (inputs) nixos-unstable;
    };

    packages = {
      discordo = inputs'.discordo.packages;
    };

    homeModules = {
      discordo = inputs.discordo.homeManagerModules.default;
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
