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
  # allow these clients to connect
  users.users."ejg".openssh.authorizedKeys.keyFiles = [
    ./_pubkeys/id_rsa_mothership.pub
  ];
  # let colmena know about the identity file
  my.home.sessionVariables."SSH_CONFIG_FILE" = pkgs.writeText "colmena-ssh-config" ''
    Host *
      IdentityFile ~/.ssh/id_rsa_mothership
  '';

  # client
  programs.ssh = {
    package = pkgs.openssh;
    extraConfig =
      let
        inherit ((import ../.)) hosts;
        hostStrings =
          lib.mapAttrsToList
            (
              hostName: host: ''
                Host ${hostName}
                  HostName ${host.ip}
                  User ejg
                  IdentityFile /home/ejg/.ssh/id_rsa_mothership
              ''
            )
            hosts;
      in
      lib.concatStringsSep "\n\n" hostStrings;
  };
}
