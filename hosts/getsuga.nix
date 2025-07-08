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
      nixos-hardware = {
        inherit (inputs.nixos-hardware.nixosModules) lenovo-legion-16irx8h;
      };
    };
    other = {
      vidya = inputs'.vidya.legacyPackages.games;
    };

  };

  home = with home; [
    homes.getsuga
  ];

  nixos = with nixos; [
    # hardware
    disks.getsuga
    hw.getsuga
    hw.nvidia

    nixos-rebuild.getsuga

    # core-specfic
    nginx-localhost

    # gaming
    vidya
    gamescope
    obs
    xwayland.default

    stateversions."23-11"
  ];

}
