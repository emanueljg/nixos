{ config, pkgs, ... }: {

  my.programs.kitty = {
    settings = {
      allow_remote_control = "yes";
      background_image_layout = "tiled";
      background_opacity = "0.5";
      background_tint = "0.5";
      
    };
  };
}
