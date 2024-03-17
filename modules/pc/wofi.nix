{ config, lib, ... }: {
  my.programs.wofi = {
    enable = true;
    settings = {
      term = lib.getExe config.my.programs.kitty.package;
      key_left = "h";
      key_down = "j";
      key_up = "k";
      key_right = "l";
    };
  };
}
