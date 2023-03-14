{ 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-2211.url = "github:NixOS/nixpkgs/nixos-22.11";

  inputs.home-manager.url = "github:nix-community/home-manager";

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

  inputs.discordo = {
    url = "github:emanueljg/discordo";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.https-server-proxy.url = "path:/home/ejg/https-server-proxy";

  
  outputs = { self, nixpkgs, ... }@attrs: {

    colmena = {

      meta = {

        nixpkgs = import nixpkgs { system = "x86_64-linux"; };

        specialArgs = { inherit (attrs) home-manager sops-nix; };

        nodeSpecialArgs = {
          "crown" = { inherit (attrs) filmvisarna porkbun-ddns; };
          "void" = { inherit (attrs) papes discordo; };
          "seneca" = { inherit (attrs) papes https-server-proxy discordo; };
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

      "loki" = {
        imports = import ./hosts/loki;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = "139.144.74.51";
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

    nixosConfigurations."loki" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = import ./hosts/loki;
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
