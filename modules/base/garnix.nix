_: {
  nix.settings = {
    trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    substituters = [
      "https://hydra.nixos.org/"
      "https://cache.garnix.io"
    ];
  };
}  
