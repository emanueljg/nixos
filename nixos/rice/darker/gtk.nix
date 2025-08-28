{ pkgs, ... }:
{
  local.gtk = {
    enable = true;
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "Everforest-Dark-BL-LB";
    };
  };
}
