{ pkgs, other, ... }:
let
  zenless-zone-zero = zenless-zone-zero-200;

  zenless-zone-zero-200 = pkgs.callPackage ./package.nix {
    inherit hdiffpatch;
    inherit (other) mkWindowsApp;
    dlData = ./200.json;
    voiceLangs = [ "ja-jp" ];
  };

  hdiffpatch = pkgs.callPackage ./hdiffpatch.nix { };
in
{
  environment.systemPackages = [
    (
      pkgs.writeShellApplication
        {
          name = "zzz";
          runtimeInputs = [ zenless-zone-zero ];
          text = "nvidia-offload zenless-zone-zero";
        }
    )
    zenless-zone-zero
  ];
}
