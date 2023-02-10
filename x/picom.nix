{ config, pkgs, ... }:

{
  my.services.picom = {
    enable = true;
    activeOpacity = 0.95;
    inactiveOpacity = 0.70;
    fade = true;
    fadeDelta = 4;
  };
}
