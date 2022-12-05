{ config, lib, ... }:

{
  my.xsession.enable = true;
  my.xsession.windowManager.bspwm = {
    enable = true;
    monitors = {
      "eDP-1" = (
        builtins.map builtins.toString (
          lib.lists.range 1 10
        )
      );
    };
  };
}
