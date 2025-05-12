_: {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userEmail = "emanueljohnsongodin@gmail.com";
      userName = "emanueljg";
      signing = {
        key = "B7894700CE81CD97";
        signByDefault = false;
      };
      extraConfig = {
        safe.directory = "/etc/nixos";
      };
    };

    gh = {
      enable = true;
    };
  };

  home.shellAliases = {
    "g" = "git";
    "gs" = "g status";
    "gb" = "g branch";
    "gbd" = "gb -d";
    "gch" = "g checkout";
    "gchb" = "g checkout -b";
    "gm" = "g merge";
    "ga" = "g add";
    "gco" = "g commit -m";
    "gcoa" = "g commit -am";
    "gpush" = "g push";
    "gpull" = "g pull";
    "gl" = "g log";
    "gd" = "g diff";

    "ghi" = "gh issue";
    "ghid" = "ghi develop -c";

    "ghp" = "gh pr";
    "ghpc" = "ghp create";

    "ghr" = "gh repo";

    "gf" = "git fetch";
    "gme" = "git merge";
  };
}



