{ inputs, home, nixos, blueprints, inputs', ... }:
{

  system = "x86_64-linux";

  imports = [
    blueprints.pc
  ];

  specialArgs = {
    packages = {
      inherit (inputs'.hy3.packages) hy3;
      inherit (inputs'.hyprland.packages) hyprland;
    };
    nixosModules = {
      disko = inputs.disko.nixosModules.disko;
      nixos-hardware.lenovo-legion-16irx8h = inputs.nixos-hardware.nixosModules.lenovo-legion-16irx8h;
    };
  };

  home = with home; [
    wayland.default
    homes.getsuga
  ];

  nixos = with nixos; [
    disks.getsuga
    hw.getsuga
    hw.nvidia
    hw.bluetooth

    # tauon
    ffmpeg
    artix-games-launcher
    tor-browser
    gaming
    qbittorrent
    nixos-wayland.default
    extra-hosts
    stateversions."23-11"
    # wg-client
  ];

}
