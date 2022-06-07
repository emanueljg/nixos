{ config, ... }:

{
  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers =  [ "nvidia" ];
  hardware.opengl.enable = true;

  virtualisation = {
    docker.enableNvidia = true;
    oci-containers.containers."jellyfin" = {
      autoStart = true;
      image = "jellyfin/jellyfin";
      volumes = [
        "/var/cache/jellyfin/config:/config"
        "/var/cache/jellyfin/cache:/cache"
        "/var/log/jellyfin:/log"
        "/mnt/data:/media:ro"
      ];
      ports = [ "8096:8096" ];
      extraOptions = ["--runtime=nvidia" ];
      environment = {
        JELLYFIN_LOG_DIR = "/log";
      };
    };
  };
}
  
