{ config, lib, homeModules, pkgs, packages, ... }: {

  imports = [ homeModules.discordo ];

  programs.discordo = {
    enable = true;
    package = packages.discordo.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "ayn2op";
        repo = "discordo";
        rev = "config-flag";
        hash = "sha256-zaQDIyCzvW4mdIXck0BH2fBr0WfRHEx8xNOb8OoNWww=";

      };
    };
    settings = {
      theme.messages_text.author_color = "red";
    };
  };
}  
