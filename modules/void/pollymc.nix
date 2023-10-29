{ pkgs, pollymc, ... }: {

  my.home.packages = [ 
    pollymc.packages.${pkgs.system}.default 
  ];

  my.xsession.windowManager.i3.config.floating.criteria = [
    { title = "pollymc"; }
  ];  

}
