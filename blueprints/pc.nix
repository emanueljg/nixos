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
    rice.darker.default
    cursor
    gtk
    firefox
    media.default
    langs.default
    mime
    qutebrowser.default
    term.default
    wayland.default
    pkgs
    fontconfig
    pavucontrol
    discordo
    yt-dlp
  ];
}
