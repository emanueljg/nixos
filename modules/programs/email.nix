{ config, nixos-unstable, ... }: let
  secret = "gmail-app"; 
in {

  sops.secrets.${secret} = {
    sopsFile = ../../secrets/${secret}.yaml;
    mode = "0440";
    owner = "ejg";
    group = "wheel";
  };

  my.accounts.email.accounts."main" = {

    primary = true;
    address = "emanueljohnsongodin@gmail.com";
    flavor = "gmail.com";
    realName = "Emanuel Johnson Godin";
    signature = {
      text = ''
        Med vänliga hälsningar / Best regards,
        Emanuel Johnson Godin
      '';
      showSignature = "append";
    };

    neomutt.enable = true;

    passwordCommand = "cat ${config.sops.secrets.${secret}.path}";

    # in accounts.email.accounts."main"
    mbsync = {
      enable = true;
      create = "both";
      remove = "both";
    };

  };

  my.programs.mbsync.enable = true;
  my.services.mbsync.enable = true;

  my.programs.neomutt = {

    enable = true;

  };

}
    