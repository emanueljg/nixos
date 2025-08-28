{
  nixosModules,
  other,
  pkgs,
  ...
}:
{
  imports = [
    nixosModules.xstarbound
  ];

  programs.xstarbound = {
    enable = true;
    bootconfig.settings = {
      assetDirectories = with other.xstarbound-mods; [
        # "../xsb-assets/"
        (pkgs.fetchzip {
          url = "https://drive.usercontent.google.com/download?id=18MF0upvhuG19-NW4qgHlD4EXBwsyE7xl&export=download&authuser=0&confirm=t";
          hash = "sha256-iZxHYA7QaDmjuN7wdCNAb3DB6EyTFMxtJQjUDSPBmr0=";
          extension = "zip";
        })
        frackin-universe
        fezzed-tech
        enterable-fore-block
      ];
      storageDirectory = "/home/ejg/.local/share/xStarbound/storage";
    };
  };
}
