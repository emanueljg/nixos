{
  imports = [
    ../../hm.nix
    ./quickmarks.nix
  ];
  my.programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://www.google.com/search?q={}";
      yt = "https://invidious.snopyta.org/search?q={}";
    };
    keyBindings = {
      normal = {
        "J" = "tab-prev";
        "K" = "tab-next";
        "gJ" = "tab-move -";
        "gK" = "tab-move +";
        "ew" = "jseval -q document.activeElement.blur()";
        "eb" = "spawn --userscript /config/parts/home/programs/qutebrowser/edit-quickmarks.sh";
        ",d" = ''hint links spawn bash -lic "aurta {hint-url}"''; 
      };
    };
  };
}
