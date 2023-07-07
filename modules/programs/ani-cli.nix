{ pkgs, ... }: {
  my.home.packages = with pkgs; let
    version = "4.4";
    pkg = pkgs.ani-cli.overrideAttrs (_: {
      inherit version;
      src = fetchFromGitHub {
        owner = "pystardust";
        repo = "ani-cli";
        rev = "hex_decryption";
        sha256 = "sha256-HDpspU9OZxDET7/1rnKdGgaVEBt0gpzGtd3DuNIj7FY=";
      };
    });
  in [ pkg ];
  my.home.shellAliases = {
    "ani" = "ani-cli";
  };
}
