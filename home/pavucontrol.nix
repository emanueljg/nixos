{ pkgs, ... }: {

  home = {
    packages = with pkgs; [ pavucontrol ];
    shellAliases = {
      "pavu" = "pavucontrol";
    };
  };

}
