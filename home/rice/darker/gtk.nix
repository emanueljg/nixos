{ pkgs, ... }: {

  gtk = {
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "Everforest-Dark-BL-LB";
    };
  };
}
