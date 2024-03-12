{ pkgs, ... }: {
  imports = [ ./flood.nix ];

  services.rtorrent = {
    enable = true;
    downloadDir = "/mnt/data/dl";
    openFirewall = true;
  };

  services.flood = {
    enable = true;
    package = pkgs.buildNpmPackage rec {
      inherit (pkgs.flood) pname meta;
      version = "unstable-2024-03-12";

      src = pkgs.fetchFromGitHub {
        owner = "jesec";
        repo = pname;
        rev = "151094073562328b70bf0faabf84d9069302f3d1";
        sha256 = "sha256-zgkbnKQCRq5v5lsKQ7ZhFmtvS81W1YNLGQswye02zg0=";
      };

      npmDepsHash = "sha256-/ehD0TaxbNLiRLyoLxIwCGAFd+aoO/S9TFwUA9xMuH8=";
    };
    openFirewall = true;
    host = "0.0.0.0";
    port = 5678;
    auth.rtorrent = {
      enable = true;
      fromNixOS = true;
    };
  };

}
