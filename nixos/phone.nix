{ pkgs
, lib
, ...
}: {
  my.home.packages = with pkgs; [
    android-tools
    scrcpy
  ];

  my.home.shellAliases = {
    phone = lib.getExe pkgs.scrcpy;
  };
}
