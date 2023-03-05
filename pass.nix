{ config, pkgs, ... }:

{
  my.home.packages = with pkgs; [ 
    pass
 #     gnupg
       pinentry
    pinentry-curses
  ];

  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  my.home.shellAliases = {
    "psl" = "pass list";
    "psr" = "pass rm";
    "psi" = "pass insert";
    "psg" = "pass generate";
    "psim" = "psi -m";
    "pss" = "pass show";
    "psp" = "pass -c";
  };
}
