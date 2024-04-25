{ self, ... }: {
  programs.helix = {
    settings.theme = "my_everforest_light_soft";

    themes."my_everforest_light_soft" =
      let
        softVer = import "${self}/themes/everforest/soft.nix";
      in
      {
        inherits = "everforest_light";
        palette = softVer.bg;
      };
  };
}
