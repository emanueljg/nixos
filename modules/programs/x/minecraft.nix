{ pollymc, pkgs, ... }: {

  environment.systemPackages = [ pollymc.packages.${pkgs.system}.pollymc ];

}
