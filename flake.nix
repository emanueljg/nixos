{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
      url = "github:emanueljg/discordo?ref=add-flake";
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

    hyprlandNixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      ref = "refs/tags/v0.43.0";
      submodules = true;
      inputs.nixpkgs.follows = "hyprlandNixpkgs";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.43.0";
      inputs.hyprland.follows = "hyprland";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
    };

    configuranix = {
      url = "github:emanueljg/configuranix";
    };

    yt-dlp-web-ui = {
      url = "github:emanueljg/yt-dlp-web-ui?ref=add-nix";
    };

    archiver = {
      url = "path:/home/ejg/archiver";
    };
  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.configuranix.flakeModules.default
      ];

      systems = [ "x86_64-linux" ];

      configuranix = {
        enable = true;
        nixos.inputs = {
          nixpkgs = inputs.nixos-unstable;
        };
        home.inputs = {
          inherit (inputs) home-manager nixos-unstable;
        };
      };

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
