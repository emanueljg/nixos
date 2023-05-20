{ config, pkgs, lib, ... }:

with pkgs; let 
  openKeyChainGnuPG = gnupg.overrideAttrs(old: rec {
    version = "2.2.28";
    src = fetchurl {
      url = "mirror://gnupg/gnupg/${old.pname}-${version}.tar.bz2";
      sha256 = "sha256-b/iR/HWDqcP7nwl+4NHeChJGnUtTmX57pQZJUGN9+uw=";
    };
  });

  openKeyChainPass = pass.override {
    gnupg = openKeyChainGnuPG;
  };
in {
  my.home.packages = with pkgs; let 
  in [ 
    openKeyChainGnuPG
    openKeyChainPass
  ];

  programs.gnupg.package = openKeyChainGnuPG;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  my.home.shellAliases = {
    "psl" = "pass list";
    "psr" = "pass rm";
    "psi" = "pass insert";
    "psg" = "pass generate";
    "psim" = "psi -m";
    "pss" = "pass show";
    "psp" = "pass -c";
    "pse" = "pass edit";
  };
}
