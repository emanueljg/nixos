{ pkgs, ... }: {
  my.home.packages = with pkgs; [
    cargo
    rustc
  ];
}
