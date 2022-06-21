{ pkgs, ... }:
{
  imports = [
    ../../hm.nix
  ];
  my.programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 
      vim-nix 
    ];
    extraConfig = ''
     set number
     set tabstop=4 shiftwidth=4
     autocmd Filetype nix setlocal ts=2 sw=2
     :command Nrs !sudo nixos-rebuild switch
    '';
  };
}
