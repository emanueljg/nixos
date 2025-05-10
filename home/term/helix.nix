{ config
, pkgs
, lib
, ...
}: {
  home.sessionVariables = rec {
    EDITOR = "hx";
    SUDO_EDITOR = EDITOR;
    VISUAL = EDITOR;
  };

  # hack for setting editor as the EDITOR for login shells
  # due to upstream bug
  programs.zsh.initExtra = ''
    export EDITOR="${config.home.sessionVariables.EDITOR}"
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
        keys.normal = {

          J = "goto_previous_buffer";
          K = "goto_next_buffer";

          C-h = "jump_view_left";
          C-j = "jump_view_down";
          C-k = "jump_view_up";
          C-l = "jump_view_right";

          C-L = "hsplit";
          C-J = "vsplit";
        };
        editor = {
          auto-pairs = false;
          line-number = "relative";
          bufferline = "always";
        };
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
          dart.command = lib.getExe pkgs.dart;
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
}
