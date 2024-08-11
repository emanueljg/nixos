{ inputs, home, nixos, blueprints, ... }: {
  specialArgs.packages = inputs': with inputs'; {
    inherit (discordo.packages) default;
  };
  specialArgs.homeModules = {
    discordo = inputs.discordo.homeManagerModules.default;
  };

  parents = [
    blueprints.base
  ];

  nixos = with nixos; [
    networkmanager
    hw.bluetooth
  ];

  home = with home; [
    rice.everforest.default
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
  ];
}
