{ config, pkgs, ... }:

{
 my.home.packages = with pkgs; [ 
   pinentry.curses
   pass
 ];
 programs.gnupg.agent = {
   enable = true;
   pinentryFlavor = "curses";
 };
}
