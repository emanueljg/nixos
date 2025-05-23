{ lib, nixpkgs', ... }: {
  hardware.nvidia.open = lib.mkForce false;

  services.jellyfin = {
    enable = true;
    # openFirewall = true;
    configDir = "/var/cache/jellyfin/config";
    logDir = "/var/log/jellyfin";
  };

  # required for https://github.com/ankenyr/jellyfin-youtube-metadata-plugin
  systemd.services.jellyfin.path = [
    nixpkgs'.nixos-unstable.yt-dlp
  ];


  # virtualisation = {
  #   docker.enableNvidia = true;
  #   oci-containers = {
  #     backend = "docker";
  #     containers."jellyfin" = {
  #       autoStart = true;
  #       image = "jellyfin/jellyfin";
  #       volumes = [
  #         "/var/cache/jellyfin/config:/config"
  #         "/var/cache/jellyfin/cache:/cache"
  #         "/var/log/jellyfin:/log"
  #         "/mnt/data:/media:ro"
  #         # required jank to make docker see the GPU
  #         "/dev/nvidia-caps:/dev/nvidia-caps"
  #         "/dev/nvidia0:/dev/nvidia0"
  #         "/dev/nvidiactl:/dev/nvidiactl"
  #         "/dev/nvidia-modeset:/dev/nvidia-modeset"
  #         "/dev/nvidia-caps:/dev/nvidia-caps"
  #         "/dev/nvidia-uvm:/dev/nvidia-uvm"
  #         "/dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools"
  #       ];
  #       ports = [ "8096:8096" ];
  #       extraOptions = [ "--runtime=nvidia" ];
  #       environment = {
  #         JELLYFIN_LOG_DIR = "/log";
  #         NVIDIA_DRIVER_CAPABILITIES = "all";
  #         NVIDIA_VISIBLE_DEVICES = "all";
  #       };
  #     };
  #   };
  # };
}
