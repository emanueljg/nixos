{
  programs.helix =
    let
      theme = import ./theme.nix;
    in
    {
      settings.theme = theme.name;

      themes.${theme.name} = {
        inherits = "everforest_light";
        palette = theme.bg;
      };
    };
}
