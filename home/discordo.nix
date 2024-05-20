{ config, lib, homeModules, ... }: {

  imports = [ homeModules.discordo ];

  programs.discordo = {
    enable = true;
    settings = {
      timestamps = true;
      timestamps_before_author = true;
      timestamps_format = "15:04";

      theme.messages_text.author_color = "red";
    };
    tokenCommand =
      let
        passBin = lib.getExe config.programs.password-store.package;
        token = "discord-token";
      in
      "${passBin} ${token}";
  };
}  
