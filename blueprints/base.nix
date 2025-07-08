{ inputs, blueprints, nixos, home, inputs', ... }: {

  imports = [
    blueprints.opts
  ];

  specialArgs.nixosModules = {
    inherit (inputs.sops-nix.nixosModules) sops;
  };
  specialArgs.homeModules = {
    inherit (inputs.sops-nix.homeManagerModules) sops;
  };
  specialArgs.packages = {
    inherit (inputs'.configuranix.packages) deploy-rs;
  };
  deploy = rec {
    sshUser = "ejg";
    profiles = {
      system.user = "root";
      home-manager.user = sshUser;
    };
  };

  nixos = with nixos; [
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
    nix-gh-pat
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
    default-cache
  ];
}  
