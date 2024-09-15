{ inputs, home, nixos, blueprints, config, ... }: {

  system = "x86_64-linux";

  specialArgs.packages = inputs': with inputs'; {
    inherit (hy3.packages) hy3;
    inherit (hyprland.packages) hyprland;
  };

  specialArgs.nixosModules = {
    disko = inputs.disko.nixosModules.disko;
    hardware = inputs.nixos-hardware.nixosModules.lenovo-legion-16irx8h;
  };

  parents = [
    blueprints.pc
  ];

  home = with home; [
    wayland.default
    ./hm.nix
    ./vccvpn.nix
    ./artix-games-launcher.nix
    ./qbittorrent.nix
    ./tor-browser.nix
    ./tauon.nix
    ./ffmpeg.nix
  ];

  nixos = with nixos; [
    ./configuration.nix
    gaming
    hw.nvidia
    nixos-wayland.default
    ./hardware.nix
    { custom.efi-grub.enable = true; }
    hw.bluetooth
    extra-hosts
    # wg-client
  ];

}
