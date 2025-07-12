{ inputs, blueprints, nixos, home, inputs', ... }: {

  imports = [
    blueprints.opts
  ];

  specialArgs.nixosModules = {
    inherit (inputs.sops-nix.nixosModules) sops;
  };

  nixos = with nixos; [
    packages
    lib
    lan.default
    keyboard
    enable-flakes
    garnix
    pkgs
    openssh-server
    swedish-locale
    user
    sops
    wg.default
    hw.libinput
    hw.efi-grub
    bat
    nnn.default
    aliases
    access-tokens
    direnv
    keep-outputs-and-derivations
    starship
    git
    pass
    gpg
    helix
    zsh
    kitty
  ];
  home = with home; [
  ];
}  
