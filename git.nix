{ config, ... }:

{
  my.programs = {
      git = {
        enable = true;
        userEmail = "emanueljohnsongodin@gmail.com";
        userName = "emanueljg";
        extraConfig = {
          safe.directory = "/etc/nixos";
        };
      };
      
      gh.enable = true;
    };
}
