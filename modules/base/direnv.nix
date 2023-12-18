{pkgs, ...}: {
  my.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  my.home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };
}
