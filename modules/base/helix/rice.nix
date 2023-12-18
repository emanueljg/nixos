{...}: {
  my.programs.helix.settings.theme = "my_everforest_light_soft";

  my.programs.helix.themes."my_everforest_light_soft" = let
    softVer = import ../../themes/everforest/soft.nix;
  in {
    inherits = "everforest_light";
    palette = softVer.bg;
  };
}
