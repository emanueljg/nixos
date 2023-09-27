{ config, pkgs, ... }: {
  services.pcscd = {
    enable = true;
  };
}
