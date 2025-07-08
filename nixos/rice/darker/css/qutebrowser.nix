{
  local.programs.qutebrowser.stylesheets = {
    "invidious" = {
      includes = [ "https://yt.emanueljg.com*" ];
      css = builtins.readFile ./invidious.css;
    };
  };
}
