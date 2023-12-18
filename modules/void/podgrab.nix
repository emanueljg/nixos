{
  config,
  lib,
  ...
}: {
  services.podgrab = {
    enable = true;
    port = 8001;
  };
  # systemd service: podgrab
  systemd.services.podgrab = lib.mkIf config.services.podgrab.enable {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "ejg";
      Group = "users";
    };
    environment.DATA = lib.mkForce "/mnt/data/audio/Podcasts";
  };
}
