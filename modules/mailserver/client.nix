{...}: let
  inherit (import ./secrets.nix) clientSecret sopsCfg;
in {
  sops.secrets.${clientSecret} = {
    inherit (sopsCfg) sopsFile mode;
    owner = "ejg";
    group = "wheel";
  };
}
