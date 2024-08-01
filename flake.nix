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

    nixGL = {
      url = "github:nix-community/nixGL";
    };

    deploy-rs.url = "github:emanueljg/deploy-rs?ref=add-meta-mainprogram";

    configuranix = {
      url = "path:/home/ejg/configuranix";
      inputs.deploy-rs.follows = "deploy-rs";
    };

  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.configuranix.flakeModules.default
      ];

      systems = [ ];

      configuranix = {
        enable = true;
        nixos.inputs = {
          inherit (inputs) nixpkgs;
        };
        home.inputs = {
          inherit (inputs) home-manager nixos-unstable;
        };
        # deploy = rec {
        #   user = "ejg";
        #   sshUser = "ejg";
        #   sshOpts = [
        #     "-i"
        #     "/home/${sshUser}/.ssh/id_rsa_mothership"
        #   ];
        # };

      };
    };
}
