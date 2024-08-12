{
  programs.qutebrowser.stylesheets = {
    "invidious" = {
      includes = [ "yt.emanueljg.com*" ];
      css = builtins.readFile ./invidious.css;
    };
  };
}
