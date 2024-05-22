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

    # discordo = {
    #   url = "path:/home/ejohnso3/discordo";
    # };
    discordo = {
      url = "github:emanueljg/discordo?ref=add-flake";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    # wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # tf-vault-backend = {
    #   # url = "github:volvo-cars/terraform-vault-bridge";
    #   url = "git+ssh://git@github.com/volvo-cars/terraform-vault-bridge.git?ref=14-explore-state-chunking";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland?ref=v0.39.1"; # where {version} is the hyprland release version
    # or "github:hyprwm/Hyprland" to follow the development branch

    hy3 = {
      url = "github:tuxx/hy3?ref=patch-1";
      inputs.hyprland.follows = "hyprland";
      # url = "github:outfoxxed/hy3?ref=hl0.39.1";
    };

    haumea = {
      url = "github:nix-community/haumea";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
    };

  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./flake-module.nix
      ];

      systems = [ "x86_64-linux" ];

      nixcfg = {
        enable = true;
        # blueprints."pc" = {
        #   specialArgs = {
        #     inherit (inputs) discordo;
        #   };
        # };
        # blueprints."base" = {
        #   specialArgs = {
        #     inherit (inputs) sops-nix;
        #   };
        # };
        # blueprints."opts" = { };
        # hosts."oakleaf" = rec { };
        # hosts."void" = rec {
        #   system = "x86_64-linux";
        #   specialArgs = {
        #     nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
        #   };
        # };
        # hosts."oakleaf" = rec {
        #   system = "x86_64-linux";
        #   specialArgs = {
        #     inherit (inputs) hy3 hyprland nixGL;
        #   };
        # };
      };

    };
}
