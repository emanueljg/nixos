{ home, blueprints, ... }: {
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
