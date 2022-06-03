{ lib, ... }:

let
  version = "21.11";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${version}.tar.gz";
in {
  imports = [ 
    (import "${home-manager}/nixos") 
    (lib.mkAliasOptionModule ["my"] ["home-manager" "users" "ejg"] )
  ];
  my.home.stateVersion = version;
}
