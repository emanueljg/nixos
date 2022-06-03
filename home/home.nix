{ config, pkgs, lib, ... }:


{
  imports = [
    ./hm.nix
    ./env.nix
    ./misc.nix
    ./pkgs.nix
    ./programs/autorandr/autorandr.nix
    ./programs/rtorrent/rtorrent.nix
    ./programs/qutebrowser/qutebrowser.nix
    ./programs/i3/i3.nix
    ./programs/neovim/neovim.nix
    ./programs/git/git.nix
    ./programs/kitty/kitty.nix
  ];
  home-manager.users.ejg = {

    xsession = {
      enable = true;
    };
  };
}

