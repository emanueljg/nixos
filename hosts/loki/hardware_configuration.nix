{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_scsi" "ahci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "ipv6.disable=1" ];
  networking.enableIPv6 = false;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cfa3834a-c6ec-0c85-1b68-6345a69f3759";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/eb677753-ccfe-4c50-bb91-efe70bdacdf6"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
