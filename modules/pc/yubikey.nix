{
  config,
  pkgs,
  ...
}: {
  services.pcscd = {
    enable = true;
  };

  my.xsession.windowManager.i3.config.floating.criteria = [
    {title = "YubiKey Onboarding";}
  ];
}
