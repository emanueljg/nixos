{
  config,
  nixos-unstable,
  ...
}: {
  my.programs = {
    git = {
      enable = true;
      userEmail = "emanueljohnsongodin@gmail.com";
      userName = "emanueljg";
      signing = {
        key = "B7894700CE81CD97";
        signByDefault = false;
      };
      extraConfig = {
        safe.directory = "/etc/nixos";
      };
    };

    gh = {
      enable = true;
      package = nixos-unstable.gh;
    };
  };
}
