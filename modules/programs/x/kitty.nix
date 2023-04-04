{ pkgs, ... }: {

  my.programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Regular Nerd Font Complete Mono";
      package = pkgs.nerdfonts;
      #package = pkgs.jetbrains-mono;
      #name = "IBM Plex Mono";
      #package = pkgs.ibm-plex;
      size = 18;
    };
    theme = "Tokyo Night Storm";
    settings = {
      confirm_os_window_close = "0";
    };
  };
}
