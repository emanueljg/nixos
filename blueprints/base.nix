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
    keyboard
    enable-flakes
    garnix
    pkgs
    openssh-server
    swedish-locale
    user
    sops
    hw.libinput
    hw.efi-grub
  ];
  home = with home; [
    default-cache
    aliases
    bat
    direnv
    git
    helix
    nnn.default
    pass
    starship
    zsh
    kitty
    openssh-client
    sops
    nix-gh-pat
    deploy-rs
  ];
}  
