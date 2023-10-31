{ pkgs, f5fpc, ... }: let _pkgs = f5fpc.packages.${pkgs.system}; in {

  my.home.packages = builtins.attrValues f5fpc.packages.${pkgs.sytem};

}
