{ deploy-rs, pkgs, ... }: {
  my.home.packages = [
    deploy-rs.packages.${pkgs.system}.default
  ];
}
