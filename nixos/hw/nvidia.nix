{ config, lib, ... }: {
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
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
  ];
}
  
