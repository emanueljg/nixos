{ config, pkgs, ... }:

{
  my.home.packages = with pkgs; [
    (
      texlive.combine {
        inherit (pkgs.texlive) 
          scheme-basic
          blindtext
        ;
      }
    )
  ];
}
