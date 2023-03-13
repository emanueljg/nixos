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
    
    "programs/neovim.nix"
    "programs/zsh.nix"
    "programs/git.nix"   
  ];
}


