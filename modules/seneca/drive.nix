{config, ...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6b3abb60-4f69-4779-83ff-8765e3bdbab6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3966-8D70";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/b24f8679-5735-45d0-8d28-356a0692c23c";}
  ];
}
