{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    papes = {
      url = "github:emanueljg/papes";
      flake = false;
    };

    discordo = {
      url = "github:emanueljg/discordo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pollymc = {
      url = "github:fn2006/PollyMC";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    f5fpc = {
      url = "github:emanueljg/f5fpc-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tf-vault-backend = {
      # url = "github:volvo-cars/terraform-vault-bridge";
      url = "git+ssh://git@github.com/volvo-cars/terraform-vault-bridge.git?ref=14-explore-state-chunking";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { self'
        , system
        , pkgs
        , ...
        }:
        let
          formatter = "nixpkgs-fmt";
        in
        {
          formatter = pkgs.${formatter};
          checks = {
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                ${formatter} = { enable = true; };
                deadnix = { enable = true; };
                statix = { enable = true; };
              };
              settings = {
                statix.ignore = [ "*hardware_configuration.nix" ];
              };
            };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ statix ];
            inherit (self'.checks.pre-commit-check) shellHook;
          };

          # creates a wsl tarball
          packages.default = self.nixosConfigurations.weasel.config.system.build.tarballBuilder;
        };

      flake =
        let
          hosts = import ./modules/hosts;
          utils = import ./utils.nix;

          rawInputs = {
            inherit (inputs) nixpkgs nixpkgs-unstable nixos-unstable;
          };

          system' = "x86_64-linux";

          pkgs = import rawInputs.nixpkgs { system = system'; };
        in
        {
          inherit pkgs;
          colmena =
            {
              meta = {
                nixpkgs = pkgs;
                specialArgs = inputs;
                nodeSpecialArgs = utils.mkColmenaSystemizeInputs hosts rawInputs;
              };
            }
            // utils.mkColmenaHosts hosts;

          nixosConfigurations =
            utils.mkNixosConfigurations { inherit hosts inputs rawInputs; };
        };
    };
}
