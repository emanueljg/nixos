{ inputs, config, pkgs, lib, ... }: {
  home.shellAliases."hypr" = "${lib.getExe inputs.nixGL.packages.${pkgs.system}.nixGLIntel} ${lib.getExe config.wayland.windowManager.hyprland.package}";
}
