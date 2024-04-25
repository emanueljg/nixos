{ config, lib, ... }: {
  programs.wofi = {
    enable = true;
    settings = {
      term = lib.getExe config.programs.kitty.package;
      key_left = "h";
      key_down = "j";
      key_up = "k";
      key_right = "l";
    };
  };
}
