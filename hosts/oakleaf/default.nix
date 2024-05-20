{ inputs, home, nixos, blueprints, config, ... }: {

  system = "x86_64-linux";

  specialArgs.packages = inputs': with inputs'; {
    inherit (hy3.packages) hy3;
    inherit (hyprland.packages) hyprland;
    inherit (nixGL.packages) nixGLIntel;
  };

  parents = [
    blueprints.pc
  ];

  home = with home; [
    wayland.default
    ./hm.nix
    ./vccvpn.nix
    ./nixGL.nix
  ];

  nixos = [
    { boot.isContainer = true; }
  ];

}
