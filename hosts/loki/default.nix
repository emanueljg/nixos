with (import ../../lib/funcs.nix); mkhost "loki" {
  blueprints = [ "core.nix" ];
  modules = [ 
    "services/devop22.nix"
    "services/ssh/ROOT_SSH.nix"
  ];
}


