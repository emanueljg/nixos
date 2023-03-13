{ config, pkgs, lib, ... }:

let currentShell = "zsh"; in {
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
    plugins = with pkgs.vimPlugins; [ 
      colorizer
      vim-nix 
      wal-vim
    ];
    extraConfig = ''
     " OLD
     set number
     set relativenumber
     set tabstop=4 shiftwidth=4 expandtab
     colorscheme wal

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
  };
}
