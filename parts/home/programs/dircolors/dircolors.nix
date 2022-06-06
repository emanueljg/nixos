{ config, ... }:

{
  imports = [
    ../../hm.nix
  ];

  my.programs.dircolors.settings = {
    OTHER_WRITABLE = "01;33";
  }
}
