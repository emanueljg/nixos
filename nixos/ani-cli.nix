{ pkgs, ... }: {
  ennvironment = {
    sysemPackages = [ pkgs.ani-cli ];
    shellAliases = {
      "ani" = "ani-cli";
    };
  };
}
