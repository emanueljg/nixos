{ config, lib, nh, ... }: with lib; {

  imports = [
    nh.nixosModules.default
  ];

  options.nh = {
    specialisation = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = {
    nh = {
      enable = true;
      flake = "/etc/nixos";
    };

    my.home.shellAliases."nrs" = "nh os switch ${lib.cli.toGNUCommandLineShell {} {
      inherit (config.nh) specialisation;
    }}";
  };

}


