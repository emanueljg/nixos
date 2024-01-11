{ pkgs
, ...
}:
{
  my.home.packages = with pkgs; [
    gnupg
    # openKeyChainGnuPG
    pass
    # openKeyChainPass
  ];

  # programs.gnupg.package = openKeyChainGnuPG;
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
