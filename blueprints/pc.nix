{ inputs, home, blueprints, ... }: {
  specialArgs.packages = inputs': with inputs'; {
    inherit (discordo.packages) default;
  };
  specialArgs.homeModules = {
    discordo = inputs.discordo.homeManagerModules.default;
  };

  parents = [
    blueprints.base
  ];

  nixos = [ ];

  home = with home; [
    firefox
    media.default
    langs.default
    mime
    qutebrowser.default
    term.default
    wayland.default
    pkgs
    pavucontrol
    discordo
  ];
}
