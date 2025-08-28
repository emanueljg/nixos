{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
  hardware.nvidia.prime =
    let
      pCfg = config.hardware.nvidia.prime;
      primeEnabled = pCfg.nvidiaBusId != "" && (pCfg.intelBusId != "" || pCfg.amdgpuBusId != "");
    in
    lib.mkIf primeEnabled {
      offload.enable = false;
      sync.enable = true;
    };
  local.allowed-unfree.names = [
    "nvidia-x11"
    "nvidia-settings"
  ];
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
}
