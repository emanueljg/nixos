{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  # allow ejg to remote build
  nix.settings.trusted-users = [ "ejg" ];

  # service
  services.openssh = {
    enable = true;
    listenAddresses = [
      {
        addr = config.local.wg.thisCfg.ip;
        port = 22;
      }
      {
        addr = "127.0.0.1";
        port = 22;
      }
      # for whatever reason, networking.hosts adds '127.0.0.2 <localhost hostname>' to /etc/hosts
      # ssh ejg@$(hostname) requests will probably route to this ip instead of the classical 127.0.0.1
      # https://github.com/NixOS/nixpkgs/blob/3e3afe5174c561dee0df6f2c2b2236990146329f/nixos/modules/config/networking.nix#L175
      {
        addr = "127.0.0.2";
        port = 22;
      }
      (lib.mkIf (config.local.lan != null) {
        addr = config.local.lan;
        port = 22;
      })
    ];
    settings = {
      # since ssh is now only active in the wireguard subnet, we
      # cah be permissive and go back to pass auth
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };

  };
  # while we're now allowing pass auth, this is a fast-track without putting in a password
  users.users."ejg".openssh.authorizedKeys.keyFiles =
    let
      keys = [
        "ejg@getsuga.pub"
      ];
    in
    map (key: ./. + "/pubkeys/${key}") keys;
}
