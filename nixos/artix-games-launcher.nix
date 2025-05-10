{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.callPackage
      ({ appimageTools }: appimageTools.wrapType2 rec {
        pname = "artix-games-launcher";
        version = "2.0.5";
        src =
          let
            version' = builtins.replaceStrings [ "." ] [ "_" ] version;
          in
          builtins.fetchurl {
            url = "https://launch.artix.com/archives/Artix_Games_Launcher-x86_64_${version'}.AppImage";
            sha256 = "sha256:03dyjxxmcmbndvdgm4f0vzr6lr68z94sy7fcxkaxrvkp5f7d8sds";
          };
      })
      { }
    )
  ];
}
