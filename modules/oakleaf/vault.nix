{ pkgs, ... }:
let
  address = "http://127.0.0.1:8200";
  package = pkgs.writeShellApplication {
    name = "vault";
    runtimeInputs = with pkgs; [ vault ];
    text = ''
      export VAULT_ADDR='${address}'
      vault "$@"
    '';
  };
in
{
  services.vault = {
    enable = true;
    inherit package address;
    dev = true;
    devRootTokenID = "foo";
  };

  my.home.packages = [ package ];
}
