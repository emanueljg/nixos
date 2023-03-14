with (import ../../lib/funcs.nix); mkhost "loki" {
  blueprints = [ "core.nix" ];
  modules = [ 
    "programs/jq.nix"
  ];
}


