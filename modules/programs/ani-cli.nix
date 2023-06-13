{ pkgs, ... }: {
  my.home.packages = with pkgs; let
    version = "4.4";
    pkg = pkgs.ani-cli.overrideAttrs (_: {
      inherit version;
      src = fetchFromGitHub {
        owner = "pystardust";
        repo = "ani-cli";
        rev = "v${version}";
        sha256 = "sha256-eY5FXwNRSt4ZFnvMyPLEFnTazwsXOkuQ6zivCHD70YY=";
      };
    });
  in [ pkg ];
  my.home.shellAliases = {
    "ani" = "ani-cli";
  };
}
