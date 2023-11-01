{ pkgs, lib, ... }: {

  my.home.packages = with pkgs; [
    android-tools
  ];

  my.home.shellAliases = {
    phone = lib.getExe pkgs.scrcpy;
  };

}
    
