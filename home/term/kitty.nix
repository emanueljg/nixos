{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Regular Nerd Font Complete Mono";
      package = null; #package = pkgs.jetbrains-mono;
      #name = "IBM Plex Mono";
      #package = pkgs.ibm-plex;
      size = 18;
    };
    theme = "Everforest Light Soft";
    settings = {
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      confirm_os_window_close = "0";
      enable_audio_bell = "no";
    };
    #shellIntegration.mode = "disabled";
  };
}
