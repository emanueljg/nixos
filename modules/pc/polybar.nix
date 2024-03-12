{ pkgs, config, ... }: {
  my.services.polybar = with import ../themes/everforest/soft.nix; {
    enable = true;
    package = pkgs.polybarFull;
    script = ''
      # polybar center
    '';
    settings =
      let
        i3BarWidth = output:
          let
            workspaces = builtins.filter
              (assign: (builtins.head assign.output) == output)
              config.my.xsession.windowManager.i3.config.workspaceOutputAssign;
            chars = builtins.foldl'
              (a: b: a + builtins.stringLength b.workspace)
              0
              workspaces;
            totalLength = chars * 13 + (builtins.length workspaces) * 2 * 12;
          in
          totalLength;
        outputBar = output: attrs: attrs // {
          monitor = "\${env:MONITOR:${output}}";
          width = "${builtins.toString (i3BarWidth output)}px";

          background = fg.red;
        };
      in
      {
        "bar/left" = outputBar "DVI-I-1-1"
          {
            height = "3%";
            modules = {
              left = "i3";
            };
            bottom = true;
            offset = {
              x = 20;
              y = 20;
            };
            scroll = {
              up = "#i3.prev";
              down = "#i3.next";
            };
            font = [
              "JetBrainsMono:pixelsize=16:weight=bold;3"
            ];
            wm-restack = "i3";
            override-redirect = true;
          };
        "module/i3" = {
          type = "internal/i3";
          pin-workspaces = true;

          label =
            let
              default = {
                foreground = fg.grey2;
                padding = "12px";
                text = "%name%";
                format.padding = 0;
              };
            in
            {
              unfocused = default // {
                background = bg.bg_dim;
              };
              focused = default // {
                background = bg.bg_visual;
              };
              visible = default // {
                background = bg.bg0;
              };
            };
        };

      };
  };
}
