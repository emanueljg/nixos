{ pkgs, ... }:
{
  config =
    with pkgs;
    (
      let
        qute-translate = callPackage (
          { pkgs }:
          stdenv.mkDerivation rec {
            name = "qute-translate";

            src = pkgs.fetchFromGitHub {
              owner = "AckslD";
              repo = "Qute-Translate";
              rev = "cd2d201d17bb2d7490700b20d94495327af15e78";
              sha256 = "sha256-xCbeEAw8a/5/ZD9+aB1J7FxLLBlP65kslGtpYGn3efs=";
            };

            installPhase = "install -Dm555 translate $out/translate";
          }
        ) { };
      in
      {
        home.packages = [ qute-translate ];
        programs.qutebrowser.keyBindings.normal.",t" = "spawn --userscript ${qute-translate}/translate";
      }
    );
}
