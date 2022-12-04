{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager.url = github:nix-community/home-manager;
  # currently broken upstream
  # inputs.discordo.url = github:emanueljg/discordo;
  
  outputs = { self, nixpkgs, ... }@attrs: {
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

				./x.nix
        ./dwm/dwm.nix
				./st/st.nix
		
				./qutebrowser/qutebrowser.nix
        # upstream broke this
#				./qutebrowser/overlay.nix
				./qutebrowser/quickmarks.nix
				./qutebrowser/translate.nix
			
				./git.nix
				./python.nix
				./java.nix
				./mysql.nix
				./latex.nix
				
				./android.nix
				./pyradio.nix
				./pdf.nix

				./kitchensink.nix

        # currently broken upstream
        # ./discordo.nix
      ];
    };
  };
}
