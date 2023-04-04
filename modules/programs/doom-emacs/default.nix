{ config, pkgs, lib, nix-doom-emacs, ... }:


{ 
  my = { ... }: {
    imports = [ nix-doom-emacs.hmModule ];

    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
    };
  };

}
