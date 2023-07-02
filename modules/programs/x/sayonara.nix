{ pkgs, ... }: with pkgs; let

  bandcampDownloader = poetry2nix.mkPoetryApplication {
    projectDir = fetchFromGitHub {
      owner = "emanueljg";
      repo = "bandcamp-downloader";
      rev = "master";
      sha256 = "sha256-5bLd5AgRkIzI8lgOjGgpb/nyPZVejfcJUgZ+YZqrX9k=";
    };

    overrides = with python311Packages; poetry2nix.defaultPoetryOverrides.extend (self: super: let
      bandaidBuildInputs = {
        "bs4" = [ "setuptools" ];
      };

    in builtins.mapAttrs (name: value: 
      super.${name}.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) 
          ++ builtins.map (pkg: super.${pkg}) value;
      })
    ) bandaidBuildInputs
    );

  };

  flaggedBandcampDownloader = writeShellApplication {
    name = "bandcamp-fetch";
    runtimeInputs = [ bandcampDownloader ];
    text = ''
      bandcamp-downloader dvachy \
        --directory '/mnt/data/bandcamp' \
        --format 'flac' \
        --unzip-to '/mnt/data/audio/Music'
    '';
  };
      

in {

  my.home.packages = with pkgs; [ 
    sayonara
    bandcampDownloader
    flaggedBandcampDownloader 
  ];
}
