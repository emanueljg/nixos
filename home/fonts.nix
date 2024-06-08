{ lib, pkgs, ... }: {
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.fontconfig = {
    enable = lib.mkForce true;
  };
}
    
