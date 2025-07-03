{ config, inputs, home, nixos, blueprints, inputs', ... }:
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
    other = {
      inherit (inputs.erosanix.lib.${config.system}) mkWindowsApp;
    };

  };

  home = with home; [
    wayland.default
    homes.getsuga
    pipe-viewer.default

  ];

  nixos = with nixos; [
    # dns.peer

    disks.getsuga
    hw.getsuga
    hw.nvidia
    hw.bluetooth

    gpu-screen-recorder
    nginx-localhost

    # vintagestory
    balatro.default
    # zenless-zone-zero.default
    gamescope


    tauon
    ffmpeg
    artix-games-launcher
    tor-browser
    qbittorrent
    nixos-wayland.default
    stateversions."23-11"
  ];

}
