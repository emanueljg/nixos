{ pkgs, nixpkgs', ... }: {
  environment.systemPackages = [
    pkgs.tauon
    pkgs.picard
  ];
}
