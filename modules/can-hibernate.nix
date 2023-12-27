{ config
, pkgs
, ...
}: {
  environment.systemPackages = [ pkgs.pmutils ];
  my.home.shellAliases."hib" = "sudo pm-hibernate";

  boot.resumeDevice = (builtins.head config.swapDevices)."device";
}
