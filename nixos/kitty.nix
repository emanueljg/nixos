{
  local.programs.kitty = {
    enable = true;
    settings = {
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      confirm_os_window_close = "0";
      enable_audio_bell = "no";
    };
  };
}
