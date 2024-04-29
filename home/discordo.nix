{ config, lib, discordo, ... }: {

  imports = [ discordo.homeManagerModules.default ];

  programs.discordo = {
    enable = true;
    settings = {
      timestamps = true;
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
