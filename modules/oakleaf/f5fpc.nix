{ pkgs, f5fpc, ... }: {

  my.home.packages = builtins.attrValues f5fpc.packages.${pkgs.system};

}
