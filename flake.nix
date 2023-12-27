{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # don't follow; currently bugged and shows 23.05 instead of 23.11
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      # inputs.nixpkgs.follows = "nixos-unstable";
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

    # inputs.bandcamp-artist-dl = {
    #   url = "path:/home/ejg/bandcamp-artist-dl";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
  };

  outputs = inputs @ { flake-parts, ... }:
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
                statix.ignore = [ "*hardware{_,-}configuration.nix" ];
              };
            };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ statix ];
            inherit (self'.checks.pre-commit-check) shellHook;
          };
        };

      flake =
        let
          inherit (import ./modules) utils hosts;

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
