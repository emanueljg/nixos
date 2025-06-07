{ pkgs, ... }:
let
  pkg = pkgs.writeShellScript {
    name = "vs";
    text = ''
      nvidia-offload vintagestory
    '';
  };
in
{
  environment.systemPackages = [ pkg ];
}
