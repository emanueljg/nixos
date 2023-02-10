{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager.url = github:nix-community/home-manager;

  inputs.papes = {
    url = github:emanueljg/papes;
    flake = false;
  };

  # currently broken upstream
  # inputs.discordo.url = github:emanueljg/discordo;
  
  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations."crown" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./crown.nix
        ./2211-state.nix

        ./enable-flakes.nix
        ./allow-unfree.nix
        ./hm.nix
        ./git.nix

        ./aliases.nix
        ./user.nix
	      ./neovim.nix
	      ./zsh.nix
	      ./pfetch.nix

        ./boot.nix 
        ./locale.nix
        ./stateful-network.nix
      ];
  };
    nixosConfigurations."void" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./void.nix
	./void-hw.nix
	./2211-state.nix

	./enable-flakes.nix
	./allow-unfree.nix
	./hm.nix
	./misc-pkgs.nix
	./git.nix

        ./boot.nix 
        ./sound.nix
	./locale.nix
	./stateful-network.nix


  ./aliases.nix
        ./user.nix
	./neovim.nix
	./zsh.nix
	./pfetch.nix
	./jq.nix
	
  ./langs/python.nix
	./langs/java.nix
	./langs/nodejs.nix
	./langs/mysql.nix
	
	./pyradio.nix

        ./x/x.nix
          ./x/nvidia.nix
          ./x/i3.nix
          ./x/st/st.nix

          ./x/qutebrowser/qutebrowser.nix
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

        # currently broken upstream
        # ./discordo.nix
      ];
    };
  };
}
