{ pkgs, ... }: {
  home.packages = [
    pkgs.tauon
    pkgs.picard
  ];
}
