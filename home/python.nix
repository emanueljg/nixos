{ pkgs, ... }: {
  home.packages = with pkgs; [
    (python311.override { x11Support = true; })
    poetry
  ];
}
