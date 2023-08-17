{ 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs-stable";
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

  inputs.bandcamp-artist-dl = {
    url = "path:/home/ejg/bandcamp-artist-dl";
    inputs.nixpkgs.follows = "nixpkgs";
  };

 # inputs.nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
 
  outputs = { self, nixpkgs, ... }@attrs: {

    colmena = {

      meta = {

        nixpkgs = import nixpkgs { system = "x86_64-linux"; };

        specialArgs = { inherit (attrs) home-manager sops-nix; };

        nodeSpecialArgs = {
          "void" = { inherit (attrs) papes discordo bandcamp-artist-dl; };
          "seneca" = { inherit (attrs) papes discordo; };
        };

      };

      "seneca" = {
        imports = import ./hosts/seneca;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = "192.168.0.4";
        };
      };

      "crown" = {
        imports = import ./hosts/crown;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = "192.168.0.2";
        };
      };

      "void" = {
        imports = import ./hosts/void;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = "127.0.0.1";
        };
      };

      "fenix" = {
        imports = import ./hosts/fenix;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = "95.217.219.33";
        };
      };

    };

    nixosConfigurations."void" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = import ./hosts/void;
    };

    nixosConfigurations."crown" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = import ./hosts/crown;
    };
        
    nixosConfigurations.seneca = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = import ./hosts/seneca;
    };
  };
}
