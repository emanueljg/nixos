{ config, pgks, ... }:

{
  my.programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://www.google.com/search?q={}";
      yt = "http://192.168.1.2:34030/search?q={}";
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
  };
  # required for qutebrowser to work iirc
  hardware.opengl.enable = true;
}