{ pkgs, ... }:
{
  local.cursor = {
    enable = true;
    package = pkgs.borealis-cursors;
    name = "Borealis-cursors";
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
