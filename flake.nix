{ 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    # don't follow; currently bugged and shows 23.05 instead of 23.11
    inputs.nixpkgs.follows = "nixpkgs-unstable";
    # inputs.nixpkgs.follows = "nixos-unstable";
  };

  inputs.papes = {
    url = "github:emanueljg/papes";
    flake = false;
  };

  inputs.discordo = {
    url = "github:emanueljg/discordo";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.dometodik = {
    url = "github:emanueljg/dometodik";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # inputs.bandcamp-artist-dl = {
  #   url = "path:/home/ejg/bandcamp-artist-dl";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };

  inputs.pollymc = {
    url = "github:fn2006/PollyMC";
  };

  inputs.f5fpc = {
    url = "github:emanueljg/f5fpc-nix";
    # inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.factorio-server =  {
    # url = "path:/home/ejg/factorio-server-nix";
    url = "github:emanueljg/factorio-server-nix";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }@attrs: let
    inherit (import ./modules)
      utils
      hosts
    ;
    system = "x86_64-linux";
    appliedAttrs = attrs // { 
      nixpkgs-unstable = import attrs.nixpkgs-unstable { inherit system; };
    };
  in {

    colmena = {
      meta = {
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        specialArgs = appliedAttrs;
      };
    } // utils.mkColmenaHosts hosts;

    nixosConfigurations = utils.mkNixosConfigurations {
      inherit hosts nixpkgs; attrs = appliedAttrs;
    };
  };
}
