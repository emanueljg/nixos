{
  config,
  pkgs,
  ...
}: {
  my.nixpkgs.overlays = [
    (
      self: super: {
        qutebrowser = let
          pywalQute = pkgs.callPackage (
            {pkgs}:
              pkgs.python3Packages.buildPythonPackage rec {
                name = "pywalQute";
                src = pkgs.fetchFromGitHub {
                  owner = "makman12";
                  repo = "pywalQute";
                  rev = "master";
                  sha256 = "sha256-hTVhVdn3OMG+mLE87/dopANIEZ3laRPoys/dOTbBsZM=";
                };

                preBuild = ''
                  mv draw.py pywalQute.py
                  echo "from setuptools import setup" >> setup.py
                  echo 'setup(name="pywalQute", version="1.0", py_modules=["pywalQute"])' >> setup.py
                  chmod +x setup.py
                '';
              }
          ) {pkgs = super;};
        in
          super.qutebrowser.overrideAttrs (
            oldAttrs: {
              propagatedBuildInputs =
                oldAttrs.propagatedBuildInputs
                ++ [pywalQute];
            }
          );
      }
    )
  ];

  my.programs.qutebrowser.extraConfig = ''
    # import pywalQute
    #
    # pywalQute.color(c, {
    #     'spacing': {
    #         'vertical': 6,
    #         'horizontal': 8
    #     }
    # })
  '';
}
