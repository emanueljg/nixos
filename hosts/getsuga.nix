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
      vidya = inputs'.vidya.legacyPackages.games;
    };

  };

  home = with home; [
    homes.getsuga
  ];

  nixos = with nixos; [
    # dns.peer
    disks.getsuga

    hw.getsuga
    hw.nvidia
    hw.bluetooth

    gpu-screen-recorder
    nginx-localhost

    # TODO move
    vidya
    artix-games-launcher

    # zenless-zone-zero.default
    gamescope
    pipe-viewer.default
    tauon
    ffmpeg
    obs

    stateversions."23-11"
  ];

}
