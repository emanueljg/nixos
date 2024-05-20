{ packages, config, pkgs, lib, ... }: {
  home.shellAliases."hypr" = "${lib.getExe packages.nixGLIntel} ${lib.getExe config.wayland.windowManager.hyprland.package}";
}
