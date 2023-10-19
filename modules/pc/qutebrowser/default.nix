{ config, pkgs, nixpkgs-unstable, lib, ... }:

{
  imports = [
    ./quickmarks.nix
    ./translate.nix
    ./qute-pass.nix
    ./rice.nix
  ];

  my.home.packages = with pkgs; [ rmapi ];

  my.programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser-qt6;
    # package = let
    #   qtwebengine = pkgs.qt6.qtwebengine.overrideAttrs (final: prev: { 
    #     version = "6.6.0";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "qt";
    #       repo = "qtwebengine";
    #       rev = final.version;
    #       sha256 = "sha256-8nHj3SZ/PE9ayzwERHyiFwavApZRmLYMMinWwYN8168=";
    #     };
    #     patches = [ ];
    #     postPatch = "";
    #   }); 
    # in nixpkgs-unstable.qutebrowser.overridePythonAttrs(old: {
    #   propagatedBuildInputs = with nixpkgs-unstable.python3Packages; [
    #     pyyaml qtwebengine jinja2 pygments
    #     # scripts and userscripts libs
    #     tldextract beautifulsoup4
    #     readability-lxml pykeepass stem
    #     pynacl
    #     # extensive ad blocking
    #     adblock
    #   ];
    # });
    searchEngines = {
      DEFAULT = "https://www.google.com/search?q={}";
      yt = "http://192.168.0.2:34030/search?q={}";
    };
    keyBindings = {
      normal = {
        "J" = "tab-prev";
        "K" = "tab-next";
        "gJ" = "tab-move -";
        "gK" = "tab-move +";
        "ew" = "jseval -q document.activeElement.blur()";
        "eb" = "spawn --userscript /config/parts/home/programs/qutebrowser/edit-quickmarks.sh";  # doesn't work as of yet
        ",d" = ''hint links spawn zsh -lic "aurta {hint-url}"''; 
        ",yy" = ''yank inline https://youtube.com/watch?{url:query}'';
      };
    };
    settings = {
      "auto_save.session" = false;
#      colors.webpage.darkmode.enabled = true;
      "downloads.prevent_mixed_content" = false;
    };
  };
  # required for qutebrowser to work iirc
  hardware.opengl.enable = true;
}
