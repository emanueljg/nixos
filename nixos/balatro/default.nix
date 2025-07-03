{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.callPackage ./package.nix { })
  ];
}
