{ pkgs, ... }: {

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/mnt/data/audio/Music";
      Address = "localhost";
      Port = 4533;
    };
  };

  my.home.packages = with pkgs; [
    jellycli
  ];

}
