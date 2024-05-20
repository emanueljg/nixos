{ lib, pkgs, ... }: {
  programs.ssh = {
    enable = true;
    package = pkgs.openssh; # how on earth is this not default
    matchBlocks =
      let
        hosts = import ../_hosts_default.nix;
      in
      lib.mapAttrs
        (hostName: host: {
          host = hostName;
          hostname = host.ip;
          user = "ejg";
          identityFile = "~/.ssh/id_rsa_mothership";
        })
        hosts;
  };
}
		
