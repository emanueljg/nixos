{ nixpkgs', ... }: {
  programs.yt-dlp = {
    enable = true;
    package = nixpkgs'.nixos-unstable.yt-dlp;
  };
}
