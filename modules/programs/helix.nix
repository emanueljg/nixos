{ config, pkgs, ... }:

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
 my.programs.helix = with pkgs; let
    py-lsp = "${python311Packages.python-lsp-server.overrideAttrs(old: rec {
      buildInputs = (
        # enable stuff like flake8 etc
        old.buildInputs ++ old.passthru.optional-dependencies.all
      );
    })}/bin/pylsp";
    nix-lsp = "${nil}/bin/nil";
  in {
    enable = true;
    languages = {
      language = [
        ({
          name = "python";
          language-server = {
            command = py-lsp;
          };
          config = {
            pylsp = {
              configurationSources = [ "flake8" ];
              plugins = {
                flake8 = {
                  executable = "${python311Packages.flake8}/bin/flake8";
                  enabled = true;
                  maxLineLength = 88;
                };
              };
            };
          };
        })
        ({
          name = "nix";
          language-server = {
            command = nix-lsp;          
          };
        })
      ];
    };
  };
}
