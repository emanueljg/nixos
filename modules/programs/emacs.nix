{ config, pkgs, lib, ... }:

{
  my.programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };
}
