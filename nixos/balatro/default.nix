{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "balatro";
      runtimeInputs = [

        (pkgs.callPackage ./package.nix { })
      ];
      text = ''
        nvidia-offload balatro "$@"
      '';
    })
  ];
}
