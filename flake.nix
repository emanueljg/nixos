{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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

  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";


  outputs = { self, ... }@inputs:
    let

      inherit (import ./modules)
        utils
        hosts
        ;

      rawInputs = {
        inherit (inputs) nixpkgs nixpkgs-unstable nixos-unstable;
      };

      system' = "x86_64-linux";

      pkgs = import rawInputs.nixpkgs { system = system'; };

    in
    {

      colmena = {
        meta = {
          nixpkgs = pkgs;
          specialArgs = inputs;
          nodeSpecialArgs = utils.mkColmenaSystemizeInputs hosts rawInputs;
        };
      } // utils.mkColmenaHosts hosts;

      nixosConfigurations = utils.mkNixosConfigurations {
        inherit hosts inputs rawInputs;
      };

      checks.${system'} = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system'}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      };

      devShells.${system'}.default = pkgs.mkShell {
        inherit (self.checks.${system'}.pre-commit-check) shellHook;
      };

    };
}
