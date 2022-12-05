{ config, lib, ... }:

{
  services = {
    xserver = {
      displayManager = {
        session = let fakeSession = {
          manage = "window";
          name = "fake";
          start = "";
        }; in [ fakeSession ];
        defaultSession = "none+fake";
        autoLogin = {
          user = "ejg";
          enable = true;
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
