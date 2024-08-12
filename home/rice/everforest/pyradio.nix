{
  programs.pyradio =
    let
      theme = import ./_theme.nix;
    in
    {
      settings.ui.theme = theme.name;
      themes.${theme.name} = rec {

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
}
    
