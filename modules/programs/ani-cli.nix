{ pkgs, ... }: {
  my.home.packages = with pkgs; let
    version = "4.5";
    pkg = pkgs.ani-cli.overrideAttrs (_: {
      inherit version;
      src = fetchFromGitHub {
        owner = "pystardust";
        repo = "ani-cli";
        rev = "master";
        sha256 = "sha256-kn6EWyvfb9sDJgLbUvRInmlUlUXQ04+9rZ62RExtQug=";
      };
    });
  in [ pkg ];
  my.home.shellAliases = {
    "ani" = "ani-cli";
  };
}
