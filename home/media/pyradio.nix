{ self, pkgs, ... }: {
  programs.pyradio = {
    enable = true;
    settings = {
      playlist.default = "default";
      ui.theme = "everforest";
      station.connectionTimeout.interval = 30;
    };
    playlists = {
      "default".stations = [
        { name = "Lainzine"; url = "https://radio.lainzine.org:8443/music"; }
        { name = "Nightwave Plaza"; url = "http://radio.plaza.one/mp3"; }
        { name = "/a/ radio"; url = "https://stream.r-a-d.io/main.mp3"; }
        { name = "Instrumental Jazz"; url = "https://jfm1.hostingradio.ru:14536/ijstream.mp3"; }
        { name = "KEYGEN FM"; url = "http://stream.keygen-fm.ru:8082/listen.mp3"; }

        { name = "SomaFM Groove Salad"; url = "https://ice1.somafm.com/groovesalad-320-mp3"; }
        { name = "SomaFM Boot Liquor"; url = "https://ice1.somafm.com/bootliquor-320-mp3"; }
        { name = "SomaFM DEF CON"; url = "https://ice1.somafm.com/defcon-320-mp3"; }
        { name = "SomaFM Secret Agent"; url = "https://ice1.somafm.com/secretagent-320-mp3"; }
        { name = "SomaFM Cliqhop"; url = "https://ice1.somafm.com/cliqhop-320-mp3"; }

        { name = "Sveriges Radio P1"; url = "https://sverigesradio.se/topsy/direkt/132-hi-mp3.m3u"; }
        { name = "Sveriges Radio P2"; url = "https://http-live.sr.se/p2musik-aac-320"; }
        { name = "Sveriges Radio P3"; url = "https://sverigesradio.se/topsy/direkt/164-hi-mp3.m3u"; }
      ];
    };
    themes = {
      "everforest" =
        let
          theme = import "${self}/themes/everforest/soft.nix";
        in
        rec {

          station = {
            normal = { fg = theme.fg.fg; bg = theme.bg.bg0; };
            active = { fg = theme.fg.green; };
          };

          statusBar = { fg = theme.fg.fg; bg = theme.bg.bg2; };

          cursor = {
            normal = { fg = theme.fg.fg; bg = theme.bg.bg2; };
            active = { fg = theme.bg.bg0; bg = theme.fg.green; };
            edit = { fg = "#1E1E2E"; bg = "#F5E0DC"; };
          };

          extraFunc = { fg = theme.fg.purple; };

          pyradioUrl = { fg = station.normal.bg; }; # hide it

          messagesBorder = { fg = theme.fg.green; };

          transparency = 0;

        };
    };
  };
}
