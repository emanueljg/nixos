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

  outputs = { self, nixpkgs, ... }@attrs: {

    colmena = {

      meta = {

        nixpkgs = import nixpkgs { system = "x86_64-linux"; };

        specialArgs = { inherit (attrs) home-manager; };

        nodeSpecialArgs = {
          "crown" = { inherit (attrs) filmvisarna porkbun-ddns; };
          "void" = { inherit (attrs) papes discordo; };
        };

      };

      "loki" = {
        imports = import ./hosts/loki/loki.nix;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = "139.144.74.51";
        };
      };

      "crown" = {
        imports = import ./hosts/crown.nix;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = "192.168.0.2";
        };
      };

      "void" = {
        imports = import ./hosts/void.nix;
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
        modules = import ./hosts/loki/loki.nix;
    };
    nixosConfigurations."void" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
        modules = import ./hosts/void.nix;
    };

    nixosConfigurations."crown" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
        modules = import ./hosts/crown.nix;
    };
        
    nixosConfigurations.seneca = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ 
				./seneca.nix

				./enable-flakes.nix
				./allow-unfree.nix
        ./hm.nix
				./misc-pkgs.nix
				./state.nix

				./hardware.nix
				./stay-awake.nix
				./drive.nix
				./boot.nix
				./hibernation.nix
				./sound.nix
				./locale.nix
				./stateful-network.nix

				./user.nix

				./aliases.nix
				./neovim.nix
				./zsh.nix
				./pfetch.nix
        ./jq.nix

				./git.nix
				./python.nix
				./java.nix
        ./nodejs.nix
				./mysql.nix

				./pyradio.nix

        ./x/x.nix
          ./x/i3.nix
          ./x/st/st.nix

          ./x/qutebrowser/qutebrowser.nix
          # upstream broke this
          #./x/qutebrowser/overlay.nix
          ./x/qutebrowser/quickmarks.nix
          ./x/qutebrowser/translate.nix

          ./x/picom.nix
          ./x/pywal/wallpaper.nix
          ./x/pywal/pywalQute.nix

			
				  ./x/latex.nix
          ./x/android.nix

				./kitchensink.nix
      ];
    };
  };
}
