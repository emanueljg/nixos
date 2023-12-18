{pkgs, ...}: {
  my.home.packages = with pkgs; [ani-cli];
  my.home.shellAliases = {
    "ani" = "ani-cli";
  };
}
