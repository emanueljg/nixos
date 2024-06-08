{ inputs, hosts, blueprints, nixos, home, ... }: {
  specialArgs.nixosModules = {
    inherit (inputs.sops-nix.nixosModules) sops;
  };
  specialArgs.homeModules = {
    inherit (inputs.sops-nix.homeManagerModules) sops;
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
    colmena
    openssh-client
    sops
    nix-gh-pat
  ];
}  
