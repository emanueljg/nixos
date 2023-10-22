{ config, pkgs, ... }: {

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers =  [ "nvidia" ];

  virtualisation = {
    docker.enableNvidia = true;
    oci-containers = {
      backend = "docker";
      containers."jellyfin" = {
        autoStart = true;
        image = "jellyfin/jellyfin";
        volumes = [
          "/var/cache/jellyfin/config:/config"
          "/var/cache/jellyfin/cache:/cache"
          "/var/log/jellyfin:/log"
          "/mnt/data:/media:ro"
        ];
        ports = [ "8096:8096" ];
        extraOptions = [ "--runtime=nvidia" ];
        environment = {
          JELLYFIN_LOG_DIR = "/log";
          NVIDIA_DRIVER_CAPABILITIES = "all";
          NVIDIA_VISIBLE_DEVICES = "all";
        };
      };
    };
  };

}
