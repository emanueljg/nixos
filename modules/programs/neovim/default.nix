{ config, pkgs, lib, nil, ... }:

let 
  currentShell = "zsh";
in {
  environment.systemPackages = with pkgs; [
    cool-retro-term
  ];
  my.home.sessionVariables = rec {
    EDITOR = "nvim"; 
    SUDO_EDITOR = EDITOR;
    VISUAL = EDITOR;
  };

  # hack for setting editor as the EDITOR for login shells
  # due to upstream bug
  my.programs.${currentShell}.initExtra = ''
    export EDITOR="${config.my.home.sessionVariables.EDITOR}"
  '';

  # due to the nature of the hack this warning can be good
  warnings =
    lib.lists.optional
    (!config.my.programs."${currentShell}".enable) 
    ''$EDITOR hack for login shells won't work; 
    target shell (${currentShell}) not enabled.'';

  my.programs.neovim = {
    enable = true;
    coc = {
      enable = true;
      settings = {
        "languageserver" = {
          "nix" = {
            "command" = "${nil.packages.${pkgs.system}.default}/bin/nil";
            "filetypes" = ["nix"];
            "rootPatterns" = [ "flake.nix" ];
            "settings" = {
              "nil" = {
                "formatting" = { "command" = ["nixpkgs-fmt"]; };
              };
            };
          };
        };
      };
    };
    plugins = with pkgs.vimPlugins; [ 
      colorizer

      nvim-treesitter.withAllGrammars
      twilight-nvim
      tokyonight-nvim
      vim-nix 
      nvim-tree-lua

      nvim-web-devicons
      bufferline-nvim
      barbar-nvim
      #wal-vim
    ];
    extraConfig = (builtins.readFile ./coc-config.vim) + ''
     " OLD
     set number
     set relativenumber
     set termguicolors

     set tabstop=4 shiftwidth=4 expandtab
     " colorscheme gruvbox
     " colorscheme tokyonight-day
     " colorscheme solarized
     " colorscheme wal
     " colorscheme everforest
     colorscheme tokyonight-storm

     autocmd Filetype nix setlocal ts=2 sw=2
     :command Nrs !sudo nixos-rebuild switch

     " here comes the stuff from 
     " https://www.youtube.com/watch?v=XA2WjJbmmoM

     " FINDING FILES
     " Search down into subfolders
     " 
     set path+=**
     set wildmenu
    '';

    extraLuaConfig = ''
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    '' + builtins.readFile(./nvim-tree-lua.lua)
     # + builtins.readFile(./bufferline.lua);
      + builtins.readFile(./barbar.lua);
  };
}
