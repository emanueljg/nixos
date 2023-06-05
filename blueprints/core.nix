with (import ../lib/funcs.nix); mkbp {
  "blueprints" = [];
  "modules" = [
    "meta/enable-flakes.nix"
    "meta/user.nix"
    "meta/hm.nix"
    "meta/aliases.nix"
    "meta/swedish-locale.nix"
    "meta/sops.nix"

    "services/ssh/fleet-relay.nix"

    "programs/langs/python.nix"
    
   # "programs/neovim"
    "programs/helix.nix"
    "programs/zsh.nix"
    "programs/git.nix"   
    "programs/ssh.nix"
    "programs/starship.nix"

    "programs/direnv.nix"
  ];
}


