{ ... }: {
  imports = [
    ./quickmarks.nix
    ./translate.nix
    ./qute-pass.nix
    ./rice.nix
  ];

  my.programs.qutebrowser = {
    enable = true;
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
        "eb" = "spawn --userscript /config/parts/home/programs/qutebrowser/edit-quickmarks.sh"; # doesn't work as of yet
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

  # make default browser
  my.xdg.mimeApps.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };
}
