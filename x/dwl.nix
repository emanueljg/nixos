{ config, pkgs, lib, ... }:

let dwl = pkgs.dwl; somebar = pkgs.somebar; in {

  environment.systemPackages = [ dwl somebar ];

  services.xserver.displayManager.session = [{
    name = "dwl";
    manage = "window";
    start = ''
      ${dwl}/bin/dwl &
      waitPID=$!
    '';
  }];
}
