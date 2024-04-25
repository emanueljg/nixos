{ pkgs, ... }: {
  home.packages = with pkgs; [ ani-cli ];
  home.shellAliases = {
    "ani" = "ani-cli";
  };
}
