{
  inputs = {
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      ref = "refs/tags/v0.49.0";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.49.0";
      inputs.hyprland.follows = "hyprland";
    };

    configuranix = {
      url = "path:/home/ejg/configuranix";
    };

    archiver = {
      url = "path:/home/ejg/archiver";
    };

    erosanix.url = "github:emmanuelrosa/erosanix";

  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.configuranix.flakeModules.default
      ];

      systems = [ "x86_64-linux" ];

      configuranix = {
        enable = true;
        hostsPath = ./hosts;
        blueprintsPath = ./blueprints;

        moduleSets = {
          nixos.inputs = {
            nixpkgs = inputs.nixos-unstable;
          };
          home.inputs = {
            nixpkgs = inputs.nixos-unstable;
            inherit (inputs) home-manager;
          };
        };
      };

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # in lieu of inputs.nixpkgs
        _module.args.pkgs = inputs'.nixos-unstable.legacyPackages;
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
