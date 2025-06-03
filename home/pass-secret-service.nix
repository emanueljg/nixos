{ config, pkgs, ... }: {
  services.pass-secret-service = {
    enable = true;
    storePath = "${config.home.homeDirectory}/.local/share/password-store";
  };
  home.packages = [
    pkgs.libsecret
  ];
}
