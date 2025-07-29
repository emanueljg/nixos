{
  programs.firefox.enable = true;
  # make default browser
  xdg.mime.defaultApplications = {
    "text/html" = "org.firefox.firefox.desktop";
    "x-scheme-handler/http" = "org.firefox.firefox.desktop";
    "x-scheme-handler/https" = "org.firefox.firefox.desktop";
    "x-scheme-handler/about" = "org.firefox.firefox.desktop";
    "x-scheme-handler/unknown" = "org.firefox.firefox.desktop";
  };
}
