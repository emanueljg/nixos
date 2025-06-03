{ pkgs, ... }: {
  imports = [
    ./peer.nix
  ];
  services.bind = {
    enable = true;
    extraOptions = ''
      recursion no;
    '';
    # listenOn = [ "10.100.0.1" ];
    zones = {
      "void" = {
        master = true;
        file = pkgs.replaceVars ./db.generic {
          HOSTNAME = "void";
          IP = "10.100.0.1";
          SERIAL = 1;
        };
      };
    };
  };
}
