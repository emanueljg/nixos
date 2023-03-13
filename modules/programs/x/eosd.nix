{ config, pkgs, ... }:

{
  hardware.opengl.driSupport32Bit = true;
  environment.systemPackages = with pkgs; [
    (wine.override {
      openglSupport = true;
    })
    winetricks
  ];
}
