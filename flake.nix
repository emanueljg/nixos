{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    prismlauncher.url = "github:PrismLauncher/PrismLauncher";

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

    # tf-vault-backend = {
    #   # url = "github:volvo-cars/terraform-vault-bridge";
    #   url = "git+ssh://git@github.com/volvo-cars/terraform-vault-bridge.git?ref=14-explore-state-chunking";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland"; # where {version} is the hyprland release version
    # or "github:hyprwm/Hyprland" to follow the development branch

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
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
        specialArgs = {
          inherit inputs self;
        };
        blueprints."pc" = {
          path = ./blueprints/pc.nix;
        };
        blueprints."base" = {
          path = ./blueprints/base.nix;
        };
        hosts."oakleaf" = { };
      };

    };
}
