{ inputs, blueprints, nixos, home, inputs', ... }: {

  imports = [
  ];

  specialArgs.nixosModules = {
    inherit (inputs.sops-nix.nixosModules) sops;
  };

  nixos = with nixos; [
    local.default
    keyboard
    enable-flakes
    garnix
    pkgs
    openssh-server
    swedish-locale
    user
    sops
    wg
    hw.libinput
    hw.efi-grub
    bat
    nnn
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
