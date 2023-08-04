{ ... }: {

  my.programs.qutebrowser.settings.colors = with (import ../../themes); {

    completion = {

      category = {
        bg = bg.bg3;
        fg = fg.grey2;
        border.bottom = bg.bg3;
        border.top = bg.bg3;
      };
      
      odd.bg = bg.bg0;
      even.bg = bg.bg1;
      fg = fg.fg;

      item.selected = {
        bg = bg.bg_visual;
        fg = fg.fg;
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
        fg = fg.fg;
      }; 

      menu = {
        bg = bg.bg0;
        fg = fg.fg;
      };

      selected = {
        bg = bg.bg_visual;
        fg = fg.fg;
      };
    
    };

    downloads = { 

      bar.bg = bg.bg5;

      error = {
        bg = fg.red;
        fg = fg.fg;
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
      bg = bg.bg_yellow;
      fg = BLACK;
      match.fg = BLACK;
    };

    keyhint = {
      bg = bg.bg0;
      fg = fg.fg;
      suffix.fg = fg.purple;
    };

    messages = { 

      error = {
        bg = fg.purple;
        border = fg.purple;
        fg = fg.fg;
      };

      info = { 
        bg = fg.red;
        border = fg.red;
        fg = fg.fg;
      };

      warning = { 
        bg = fg.orange;
        border = fg.orange;
        fg = fg.fg;
      };
        
    };

    prompts = { 
      bg = bg.bg0;
      border = bg.bg0;
      fg = fg.fg;

      selected = { 
        bg = bg.bg_visual;
        fg = fg.fg;
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
        fg = fg.fg;
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
        fg = fg.fg;
        hover.fg = fg.aqua;
        success.http.fg = fg.green;
        success.https.fg = url.success.http.fg;
        warn.fg = fg.orange;
        error.fg = fg.red;
      };

    };

    tabs = rec { 

      bar.bg = bg.bg_green;

      even = {
        bg = bg.bg_blue;
        fg = fg.fg;
      };

      selected.even = {
        bg = bg.bg_green;
        fg = fg.fg;
      };

      odd = even;
      selected.odd = selected.even;

    };

    # TODO In later QB, need to update nixpkgs
    # tooltip = { 
    #   bg = bg.bg_visual;
    #   fg = fg.fg;
    # };

    webpage.bg = bg.bg0;

  };
}
