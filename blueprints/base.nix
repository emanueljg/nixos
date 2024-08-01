{ inputs, blueprints, nixos, home, ... }: {
  specialArgs.nixosModules = {
    inherit (inputs.sops-nix.nixosModules) sops;
  };
  specialArgs.homeModules = {
    inherit (inputs.sops-nix.homeManagerModules) sops;
  };
  specialArgs.packages = inputs': with inputs'; {
    inherit (configuranix.packages) deploy-rs;
  };
  deploy = rec {
    sshUser = "ejg";
    profiles = {
      system.user = "root";
      home-manager.user = sshUser;
    };
  };

  parents = [ blueprints.opts ];
  nixos = with nixos; [
    enable-flakes
    garnix
    pkgs
    openssh-server
    swedish-locale
    user
    sops
    hw.libinput
    { custom.efi-grub.enable = true; }
  ];
  home = with home; [
    term.default
    openssh-client
    sops
    nix-gh-pat
    deploy-rs
  ];
}  
