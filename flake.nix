{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    papes = {
      url = "github:emanueljg/papes";
      flake = false;
    };

    discordo = {
      # url = "github:emanueljg/discordo?ref=add-flake";
      url = "path:/home/ejg/discordo";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      ref = "refs/tags/v0.48.0";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.48.0";
      inputs.hyprland.follows = "hyprland";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
    };

    configuranix = {
      url = "path:/home/ejg/configuranix";
    };

    yt-dlp-web-ui = {
      url = "github:emanueljg/yt-dlp-web-ui?ref=add-nix";
    };

    archiver = {
      url = "path:/home/ejg/archiver";
    };

    succubus = {
      url = "path:/home/ejg/succubus";
    };

    nix-deno.url = "github:identinet/nix-deno";

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
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
