{config, ...}: {
  my.programs.newsboat = {
    enable = true;
    extraConfig = ''
      macro y set browser "setsid -f mpv --really-quiet --no-terminal" ; open-in-browser ; set browser ${config.my.programs.newsboat.browser}
    '';
    urls = [
      {
        # mental outlaw
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7YOGHUfC1Tb6E4pudI9STA";
      }
    ];
  };
}
