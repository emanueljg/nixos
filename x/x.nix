{ config, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      layout = "se";
      # mousepad
      libinput.enable = true;
      autoLogin = {
        user = "ejg";
        enable = true;
      };
    };
  };
  # allows for font installation
  # through home.packages
  my.fonts.fontconfig.enable = lib.mkForce true;
}
