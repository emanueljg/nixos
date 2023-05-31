{ config, pkgs, lib, ... }: 

{

  my.home.packages = with pkgs; [ 
    pass
    gnupg
  ];

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
