{ pkgs, ... }: {

  my.home.packages = with pkgs; [
    pavucontrol
  ];

  my.home.shellAliases = {
    "pavu" = "pavucontrol";
  };

}
