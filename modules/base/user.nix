{config, ...}: {
  users.users.ejg = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  my.xdg.userDirs = {
    enable = true;
    download = "${config.my.home.homeDirectory}/dl";
  };

  security.sudo.wheelNeedsPassword = false;
}
