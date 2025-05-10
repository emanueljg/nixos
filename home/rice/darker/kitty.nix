{
  programs.kitty =
    let
      theme = import ./_theme.nix;
    in
    {

      themeFile = "everforest_dark_medium";
      font = {
        name = "JetBrainsMono Nerd Font Mono";
        package = null;
        size = 18;
      };
    };
}

