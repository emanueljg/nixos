{ config, ... }:

{

  my.home.sessionVariables = rec {
    EDITOR = "hx"; 
    SUDO_EDITOR = EDITOR;
    VISUAL = EDITOR;
  };

  # hack for setting editor as the EDITOR for login shells
  # due to upstream bug
  my.programs.zsh.initExtra = ''
    export EDITOR="${config.my.home.sessionVariables.EDITOR}"
  '';

  my.programs.helix = {
    enable = true;
  };
}
