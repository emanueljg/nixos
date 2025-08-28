{
  self,
  inputs,
  modules,
  ...
}:
{

  specialArgs = {
    inherit self;
    nixosModules = {
      inherit (inputs.sops-nix.nixosModules) sops;
    };
    nixpkgs = {
      inherit (inputs) nixos-unstable;
    };
  };

  modules = with modules; [
    nix-path
    hw.libinput
    hw.efi-grub
    wrap
    local
    keyboard
    enable-flakes
    garnix
    pkgs
    openssh-server
    swedish-locale
    user
    sops
    wg
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

}
