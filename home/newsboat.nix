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
        mkYt = id: "https://www.youtube.com/feeds/videos.xml?channel_id=${id}";
      in
      [
        {
          title = "@TheLibraryofLetourneau";
          url = mkYt "UC_O58Rr2DOskJvs9bArpLkQ";
        }
        {
          title = "@LetourneauVods";
          url = mkYt "UCMZ8xVWE4PoVEQvkpGAsS6Q";
        }
        {
          title = "@2ndJerma";
          url = mkYt "UCL7DDQWP6x7wy0O6L5ZIgxg";
        }
        {
          title = "@JermaStreamArchive";
          url = mkYt "UC2oWuUSd3t3t5O3Vxp4lgAA";
        }
        {
          title = "@MandaloreGaming";
          url = mkYt "UClOGLGPOqlAiLmOvXW5lKbw";
        }
        {
          title = "@MentalOutlaw";
          url = mkYt "UC7YOGHUfC1Tb6E4pudI9STA";
        }
        {
          title = "@SsethTzeentach";
          url = mkYt "UCD6VugMZKRhSyzWEWA9W2fg";
        }
        {
          title = "@drewisgooden";
          url = mkYt "UCTSRIY3GLFYIpkR2QwyeklA";
        }
        {
          title = "@WaterflameMusic";
          url = mkYt "UCVuv5iaVR55QXIc_BHQLakA";
        }
        {
          title = "@InternetHistorian";
          url = mkYt "UCR1D15p_vdP3HkrH8wgjQRw";
        }
      ];
  };
}
