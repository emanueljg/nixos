{ config, pkgs, ... }:

{
  # https://askubuntu.com/questions/314802/is-there-a-comprehensive-list-of-mupdf-keyboard-shortcuts
  my.home.packages = with pkgs; [
    mupdf
  ];
}
