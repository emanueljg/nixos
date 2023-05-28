{ 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

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

  inputs.nil.url = "github:oxalica/nil";

 # inputs.nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

  inputs.app1-infrastruktur = {
    url = "github:emanueljg/app1-infrastruktur";
    inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  inputs.https-server-proxy = {
    url = "github:emanueljg/https-server-proxy";
    inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  inputs.nodehill-home-page = {
    url = "github:emanueljg/nodehill-home-page/php-and-mongodb";
    inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  inputs.devop22 = {
    url = "github:emanueljg/devop22-infra";
    inputs = {
      app1-infrastruktur.follows = "app1-infrastruktur";
      https-server-proxy.follows = "https-server-proxy";
      nodehill-home-page.follows = "nodehill-home-page";
      nixpkgs.follows = "nixpkgs-stable";
    };
  };

  
  outputs = { self, nixpkgs, ... }@attrs: {

    colmena = {

      meta = {

        nixpkgs = import nixpkgs { system = "x86_64-linux"; };

        specialArgs = { inherit (attrs) home-manager sops-nix; };

        nodeSpecialArgs = {
          "crown" = { inherit (attrs) filmvisarna porkbun-ddns; };
          "void" = { inherit (attrs) papes discordo; };
          "seneca" = { inherit (attrs) papes discordo nil; };
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
