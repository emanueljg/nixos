{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./rice.nix
  ];

  my = {
    home.sessionVariables = rec {
      EDITOR = "hx";
      SUDO_EDITOR = EDITOR;
      VISUAL = EDITOR;
    };

    # hack for setting editor as the EDITOR for login shells
    # due to upstream bug
    programs.zsh.initExtra = ''
      export EDITOR="${config.my.home.sessionVariables.EDITOR}"
    '';

    programs.helix =
      let
        pylsp = pkgs.python311Packages.python-lsp-server.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ old.passthru.optional-dependencies.all;
        });
      in
      {
        enable = true;
        settings = {
          editor.auto-pairs = false;
        };
        languages = {
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter = {
                command = lib.getExe pkgs.nixpkgs-fmt;
              };
            }
          ];

          language-server = {
            rust-analyzer.command = lib.getExe pkgs.rust-analyzer;
            nil.command = lib.getExe pkgs.nil;
            gopls.command = lib.getExe pkgs.gopls;
            pylsp = {
              command = lib.getExe pylsp;
              config = {
                pylsp = {
                  configurationSources = [ "flake8" ];
                  plugins = {
                    flake8 = {
                      executable = lib.getExe pkgs.python311Packages.flake8;
                      enabled = true;
                      maxLineLength = 88;
                    };
                  };
                };
              };
            };
          };
        };
      };
  };
}
