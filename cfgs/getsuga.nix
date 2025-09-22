{
  inputs,
  modules,
  configs,
  lib,
  ...
}:
cfg:
let
  parent = configs.pc;
in
{
  inherit (parent) system;

  specialArgs = lib.recursiveUpdate parent.specialArgs {
    packages = {
      inherit (inputs.hy3.packages.${cfg.system}) hy3;
      inherit (inputs.hyprland.packages.${cfg.system}) hyprland;
    };

    nixosModules = {
      disko = inputs.disko.nixosModules.disko;
      nixos-hardware = {
        inherit (inputs.nixos-hardware.nixosModules) lenovo-legion-16irx8h;
      };
    };

    other = {
      vidya = inputs.vidya.legacyPackages.${cfg.system};
    };
  };

  modules =
    parent.modules
    ++ (with modules; [
      { networking.hostName = "getsuga"; }
      # hardware
      disks.getsuga
      hw.getsuga
      hw.nvidia

      nixos-rebuild.getsuga

      # core-specfic
      nginx-localhost

      # gaming
      vidya
      fetch-from-itch
      gamescope
      obs

      network-wait-online-fix

      stateversions."23-11"
    ]);

}
