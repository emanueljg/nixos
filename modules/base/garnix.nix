_: {
  nix.settings = {
    trusted-public-keys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    substituters = [
      "https://hydra.nixos.org/"
      "https://cache.garnix.io"
    ];
  };
}  
