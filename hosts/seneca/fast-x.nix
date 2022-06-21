{ config, pkgs, ... }:

{
  services.xserver.displayManager = {
    autoLogin = {
      enable = true;
      user = "ejg";
    };
    session = let fakeSession = {
      manage = "window";
      name = "fake";
      start = "";
    }; in [ fakeSession ];
    defaultSession = "none+fake";
    lightdm.greeter.enable = false; 
  };
}
