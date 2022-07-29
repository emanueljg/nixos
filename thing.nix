{
  # _pkgs ? import (fetchTarball {
  #   name = "release-2022-07-20";
  # # https://github.com/NixOS/nixpkgs/tree/96d127077e1c87edcde25dadc1cbb246162686d4
  #   url = "https://github.com/nixos/nixpkgs/archive/96d127077e1c87edcde25dadc1cbb246162686d4.tar.gz";
  #   sha256 = "sha256:07l0jqr3ybg5mhlynnfa004rxa5x04276y03gyg43fww8fjx2c6p";    
  # }) {},

  mach-nix ? import (fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.5.0";
  }) {}

}:

# "https://github.com/AbdelrhmanNile/steal/tarball/1ce062c21fe640acd45c0801249eaa8f8f9378e5";
let
  pkgs = mach-nix.mkNixpkgs { 
    requirements = ''
      pandas
      pebble
    '';
  };
in
  pkgs.stdenv.mkDerivation rec {
    name = "steal";
  # https://github.com/AbdelrhmanNile/steal/tree/1ce062c21fe640acd45c0801249eaa8f8f9378e5
    src = pkgs.fetchFromGitHub {
      owner = "AbdelrhmanNile";
      repo = "steal";
      rev = "1ce062c21fe640acd45c0801249eaa8f8f9378e5";
      sha256 = "sha256-H67vmaB9DIAfZGBUL3HTnM4BIysOlGs6gpI8Rr2L4eE=";
    };

    nativeBuildInputs = with pkgs; [
      cmake
    ];

    buildInputs = with pkgs; [
      python39Full  # opt. minimal?
      python39Packages.kivy
      autoconf
      nodejs
      (nodePackages.webtorrent-cli.override (oldAttrs: rec {
        nativeBuildInputs = [ 
          autoconf
          automake
          nodePackages.node-gyp-build 
          nodePackages.node-gyp
          nodePackages.node-pre-gyp
        ];
        buildInputs = oldAttrs.buildInputs ++ nativeBuildInputs;

        postInstall = ''
          sed -i 's/\/usr\/bin\/env/${pkgs.bash}\/bin\/sh/g' $out/lib/node_modules/webtorrent-cli/node_modules/.bin/node-gyp-build 
        '';
          
      }))
    
      sharutils
      wine-staging
      xclip
      zpaq
      fuse-overlayfs
      tcsh
    ];
  
    buildPhrase = ''
      chmod +x build.sh && $./build.sh
    '';
  
    installPhase = ''
      mkdir -p $out/bin
      cp -p steal $out/bin/steal
      chmod 755 $out/bin/steal
    '';
  }