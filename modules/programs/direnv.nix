{ pkgs, ... }: {
  my.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
