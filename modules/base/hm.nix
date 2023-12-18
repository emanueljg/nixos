{
  config,
  lib,
  home-manager,
  ...
}: {
  imports = [
    home-manager.nixosModule
    (lib.mkAliasOptionModule ["my"] ["home-manager" "users" "ejg"])
  ];
  my.manual.manpages.enable = false;
  my.xdg.mimeApps.enable = true;
}
