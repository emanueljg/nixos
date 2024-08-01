{ lib
, pkgs
, ...
}:
with lib; {
  # allow ejg to remote build
  nix.settings.trusted-users = [ "ejg" ];

  # service
  services.openssh = {
    enable = true;
    listenAddresses = [
      {
        addr = "0.0.0.0";
        port = 22;
      }
    ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  # path literals are constructed this way to escape the @-sign.
  users.users."ejg".openssh.authorizedKeys.keyFiles =
    let
      keys = [
        "ejg@getsuga.pub"
      ];
    in
    map (key: ./. + "/pubkeys/${key}") keys;
}
