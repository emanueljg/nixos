{ config, ... }: {
  home.shellAliases."nb" = "newsboat";
  programs.newsboat = {
    enable = true;
    extraConfig = ''
      macro y set browser "setsid -f mpv --really-quiet --no-terminal" ; open-in-browser ; set browser ${config.programs.newsboat.browser}
      bind h articlelist,article,help quit
      bind j everywhere down
      bind k everywhere up
      bind l everywhere open

    '';
    urls =
      let
        ytCh = title: id: {
          inherit title;
          url = "https://www.youtube.com/feeds/videos.xml?channel_id=${id}";
        };
        ytPl = title: id: {
          inherit title;
          url = "https://www.youtube.com/feeds/videos.xml?playlist_id=${id}";
        };
      in
      [
        (ytCh "@TheLibraryofLetourneau" "UC_O58Rr2DOskJvs9bArpLkQ")
        (ytCh "@LetourneauVods" "UCMZ8xVWE4PoVEQvkpGAsS6Q")
        # sorted old-new, won't work
        # (ytPl "@TheLibraryofLetourneau - Bits & Banter" "PLvswIqZLpR-VpoMuxzO9oT3F9-FtHScpn")
        (ytCh "@2ndJerma" "UCL7DDQWP6x7wy0O6L5ZIgxg")
        (ytCh "@JermaStreamArchive" "UC2oWuUSd3t3t5O3Vxp4lgAA")
        (ytCh "@MandaloreGaming" "UClOGLGPOqlAiLmOvXW5lKbw")
        (ytCh "@MentalOutlaw" "UC7YOGHUfC1Tb6E4pudI9STA")
        (ytCh "@SsethTzeentach" "UCD6VugMZKRhSyzWEWA9W2fg")
        (ytCh "@drewisgooden" "UCTSRIY3GLFYIpkR2QwyeklA")
        (ytCh "@WaterflameMusic" "UCVuv5iaVR55QXIc_BHQLakA")
        (ytCh "@InternetHistorian" "UCR1D15p_vdP3HkrH8wgjQRw")
      ];
  };
}
