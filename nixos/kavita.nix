{ config, self, ... }:
{
  sops.secrets."kavita-token-key" = {
    sopsFile = "${self}/secrets/${config.networking.hostName}/kavita.yml";
    mode = "0440";
    owner = config.services.kavita.user;
    group = config.services.kavita.user;
  };

  services.kavita = {
    enable = true;
    tokenKeyFile = config.sops.secrets.kavita-token-key.path;
  };
}
