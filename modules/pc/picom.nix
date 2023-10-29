{ config, pkgs, ... }:

{
  my.services.picom = {
    enable = false;
    activeOpacity = 0.95;
    inactiveOpacity = 0.88;
    fade = true;
    fadeDelta = 4;
    opacityRules = [
      "1:class_g = 'slock'"
      "1:name *?= 'slock'"
    ];
  };
}
