{ config, pkgs, ... }:

{
  my.home.sessionVariables = rec {
    VISUAL = "nvim";
    EDITOR = VISUAL;
    SUDO_EDITOR = VISUAL;
  };

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
