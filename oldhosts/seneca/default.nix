{ inputs, home, nixos, blueprints, config, ... }: {

  system = "x86_64-linux";

  specialArgs.packages = inputs': with inputs'; {
    inherit (hy3.packages) hy3;
    inherit (hyprland.packages) hyprland;
  };

  parents = [
    blueprints.pc
  ];

  home = with home; [
    wayland.default
    ./hm.nix
  ];

  nixos = with nixos; [
    ./configuration.nix
    nixos-wayland.default
    hw.efi-grub
    hw.bluetooth
  ];

}
