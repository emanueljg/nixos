{ config, pkgs, ... }:
let
  pr = import
    (builtins.fetchTarball {
      url = "https://github.com/js6pak/nixpkgs/archive/110d7b29b30208a6aaa4e95b8c878e3d6e4c0709.tar.gz";
      sha256 = "sha256:1l9zw0i4zg5wmm44mn0i3hbxi67sn3z5kw6mn2dxq5rxdw2cklg5";
    })
    { system = pkgs.system; };
in
{
  programs.gpu-screen-recorder = {
    enable = true;
    package = pr.gpu-screen-recorder;
  };

  # for some reason this is not done upstream ...?
  environment.systemPackages = [
    config.programs.gpu-screen-recorder.package
  ];
}
