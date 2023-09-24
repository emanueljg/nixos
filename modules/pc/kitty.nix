{ pkgs, ... }: {

  my.programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Regular Nerd Font Complete Mono";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      #package = pkgs.jetbrains-mono;
      #name = "IBM Plex Mono";
      #package = pkgs.ibm-plex;
      size = 18;
    };
    theme = "Everforest Light Soft";
    settings = {
      confirm_os_window_close = "0";
    };
    #shellIntegration.mode = "disabled";
  };
}
