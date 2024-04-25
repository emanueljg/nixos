{ pkgs
, ...
}: {
  programs.password-store = {
    enable = true;
  };

  home.packages = with pkgs; [
    gnupg
    pass
  ];

  home.shellAliases = {
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
