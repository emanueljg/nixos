{ lib, pkgs, ... }: {
  imports = [
    ./translate.nix
    ./qute-pass.nix
    ./qute-nixpkgs-import.nix
  ];

  programs.qutebrowser = {
    enable = true;
    # package = pkgs.qutebrowser-qt5;
    package = (import
      (builtins.fetchTarball {
        url = "https://github.com/js6pak/nixpkgs/archive/81fdc23a6aa910e0ecd3ad33d7cba23f1ddc097f.tar.gz";
        sha256 = "sha256:1rb77wffwgj05l909dvpm58c4azkcnrdjyr5rdciklilv7kkhcfs";
        # sha256 = "sha256:1r2mp8yi6dsipyy0ialv89pxq3qv29skjl1ib4abcl7237xqsprk";
      })
      {
        inherit (pkgs) system;
      }).qutebrowser.override { enableVulkan = false; };

    searchEngines =
      let
        mkNixSearch = chan: type:
          # weird that you have to specify "type" two times here
          "https://search.nixos.org/${type}?channel=${chan}&type=${type}&query={}";
        mkGHSearch = type:
          "https://github.com/NixOS/nixpkgs/issues?q=is%3A${type}%20state%3Aopen%20{}";
      in
      {
        DEFAULT = "https://www.google.com/search?q={}";

        # nyaa
        nyaa = "https://nyaa.land/?q={}&s=seeders&o=desc";
        nyaa-manga = "https://nyaa.land/?q={}&c=3_1&s=seeders&o=desc";

        # nix stuff
        yt = "https://inv.nadeko.net/search?q={}";
        noog = "https://noogle.dev/q?term={}";
        nome = "https://home-manager-options.extranix.com/?query={}&release=master";
        nopt = mkNixSearch "unstable" "options";
        npkgs = mkNixSearch "unstable" "packages";
        niss = mkGHSearch "issue";
        npr = mkGHSearch "pr";

      };

    keyBindings = {
      normal = {
        "J" = "tab-prev";
        "K" = "tab-next";
        "gJ" = "tab-move -";
        "gK" = "tab-move +";
        "ew" = "jseval -q document.activeElement.blur()";
        "eb" = "spawn --userscript /config/parts/home/programs/qutebrowser/edit-quickmarks.sh"; # doesn't work as of yet
        ",d" = ''hint links spawn zsh -lic "aurta {hint-url}"'';
        ",yy" = ''yank inline https://youtube.com/watch?{url:query}'';
      };
    };
    settings = {
      # effectively disable web history popup
      "completion.web_history.max_items" = 0;

      "auto_save.session" = false;
      "downloads.prevent_mixed_content" = false;
      "url.default_page" = "http://localhost";
      "url.start_pages" = "http://localhost";
      "url.open_base_url" = true;
    };
  };
  # make default browser
  xdg.mimeApps.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };
}
