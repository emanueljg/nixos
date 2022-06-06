{ config, ... }:

{
  imports = [
    ../../hm.nix
  ];

  my.programs.dircolors = {
    enable = true;
    settings = {
      OTHER_WRITABLE = "01;33";
    };
  };
}
