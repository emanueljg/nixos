{ ... }: {
  my.programs.qutebrowser.settings.colors = with (import ../../themes); {
    completion = {
      category = {
        bg = bg.bg3;
        fg = fg.fg;

      };
    };
    contextmenu = { };
    downloads = { };
    hints = {
      bg = fg.green;
      fg = bg.bg0;
    };
  };
}
