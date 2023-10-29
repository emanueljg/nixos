{ config, pkgs, ... }: {

  my.home.packages = with pkgs; [
    teams
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "teams-1.5.00.23861"
  ];


  my.xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/msteams" = "teams.desktop";
  };
}
