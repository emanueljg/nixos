{ config, lib, ... }:

{
  services = {
    xserver = {
      displayManager = {
#        defaultSession = "none+dwl";
        autoLogin = {
          user = "ejg";
          enable = true;
        };
        sddm = {
          enable = true;
          #wayland = true;
        };
        lightdm.greeter.enable = false;
      };
      enable = true;
      layout = "se";
      # mousepad
      libinput.enable = true;
    };
  };

  # allows for font installation
  # through home.packages
  my.fonts.fontconfig.enable = lib.mkForce true;
}
