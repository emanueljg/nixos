{ pkgs, ... }: { 
  my.home.packages = with pkgs; [
    ytfzf
  ];
  my.home.shellAliases = {
    "yt" = "ytfzf -D";
  };
}
