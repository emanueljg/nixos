{ lib, ... }: {
  imports = [
    ./efi-grub.nix

    ./aliases.nix
    ./allow-unfree.nix
    ./colmena.nix
    ./direnv.nix
    ./enable-flakes.nix
    ./FIXES.nix
    ./git.nix
    ./helix
    ./hm.nix
    ./pass.nix
    ./pkgs.nix
    ./sops.nix
    ./ssh.nix
    ./starship.nix
    ./swedish-locale.nix
    ./user.nix
    ./zsh.nix
    ./opengl.nix
    ./nh.nix
    ./garnix.nix
  ];

  custom = {
    efi-grub.enable = lib.mkDefault true;
  };

}
