{ config, ... }:
{
  local.programs.qutebrowser.settings = {
    hints.border = "none";
    hints.radius = 0;

    colors =
      let
        inherit (config.local.themes."Everforest Dark Medium") bg fg WHITE;
      in
      {
        completion = {
          category = {
            bg = bg.bg3;
            fg = fg.grey2;
            border.bottom = bg.bg3;
            border.top = bg.bg3;
          };

          odd.bg = bg.bg0;
          even.bg = bg.bg1;
          inherit (fg) fg;

          item.selected = {
            bg = bg.bg_visual;
            inherit (fg) fg;
            border.bottom = bg.bg_visual;
            border.top = bg.bg_visual;
          };

          match.fg = fg.red;

          scrollbar = {
            bg = bg.bg5;
            fg = fg.green;
          };
        };

        contextmenu = {
          disabled = {
            bg = bg.bg2;
            inherit (fg) fg;
          };

          menu = {
            bg = bg.bg0;
            inherit (fg) fg;
          };

          selected = {
            bg = fg.statusline1;
            inherit (fg) fg;
          };
        };

        downloads = {
          bar.bg = bg.bg5;

          error = {
            bg = fg.red;
            inherit (fg) fg;
          };

          start = {
            bg = fg.blue;
            fg = WHITE;
          };

          stop = {
            bg = fg.green;
            fg = WHITE;
          };
        };

        hints = {
          bg = bg.bg0;
          fg = fg.fg;
          match.fg = fg.green;
        };

        keyhint = {
          bg = bg.bg0;
          inherit (fg) fg;
          suffix.fg = fg.purple;
        };

        messages = {
          error = {
            bg = fg.purple;
            border = fg.purple;
            inherit (fg) fg;
          };

          info = {
            bg = fg.red;
            border = fg.red;
            inherit (fg) fg;
          };

          warning = {
            bg = fg.orange;
            border = fg.orange;
            inherit (fg) fg;
          };
        };

        prompts = {
          bg = bg.bg0;
          border = bg.bg0;
          inherit (fg) fg;

          selected = {
            bg = bg.bg_visual;
            inherit (fg) fg;
          };
        };

        statusbar = rec {
          caret = {
            bg = fg.yellow;
            fg = WHITE;
            selection.bg = caret.bg;
            selection.fg = caret.fg;
          };

          normal = {
            bg = bg.bg0;
            inherit (fg) fg;
          };

          command = normal;

          insert = {
            bg = fg.green;
            fg = WHITE;
          };

          passthrough = {
            bg = fg.purple;
            fg = WHITE;
          };

          progress.bg = fg.green;

          url = {
            inherit (fg) fg;
            hover.fg = fg.aqua;
            success.http.fg = fg.green;
            success.https.fg = url.success.http.fg;
            warn.fg = fg.orange;
            error.fg = fg.red;
          };
        };

        tabs = rec {
          bar.bg = bg.bg0;

          even = {
            bg = bg.bg0;
            inherit (fg) fg;
          };

          selected.even = {
            bg = fg.statusline1;
            fg = bg.bg0;
          };

          odd = even;
          selected.odd = selected.even;
        };

        # webpage.darkmode.enabled = true;

        # TODO In later QB, need to update nixpkgs
        # tooltip = {
        #   bg = bg.bg_visual;
        #   fg = fg.fg;
        # };

      };
  };
}
