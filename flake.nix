{ 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  inputs.filmvisarna = {
    url = "github:emanueljg/filmvisarna-backend";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.porkbun-ddns = {
    url = "github:emanueljg/porkbun-dynamic-dns-python";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.papes = {
    url = "github:emanueljg/papes";
    flake = false;
  };

  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

 # inputs.nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
 
  outputs = { self, nixpkgs, ... }@attrs: {

    colmena = {

      meta = {

        nixpkgs = import nixpkgs { system = "x86_64-linux"; };

        specialArgs = { inherit (attrs) home-manager sops-nix; };

        nodeSpecialArgs = {
          "crown" = { inherit (attrs) filmvisarna porkbun-ddns; };
          "void" = { inherit (attrs) papes; };
          "seneca" = { inherit (attrs) papes; };
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
