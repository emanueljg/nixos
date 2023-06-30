{ pkgs, ... }: {

  imports = [
    ./kitty-album-art.nix
    # ./album-art.nix
  ];
  
  my.programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      visualizerSupport = true;
    };
    settings = {
      media_library_primary_tag = "album_artist";
    };
  };

}
    
