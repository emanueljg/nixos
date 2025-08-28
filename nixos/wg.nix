{ config, lib, ... }:
{

  # config = lib.mkMerge [
  #   {
  #     local.wg.hosts =
  #       let
  #         server = "void";
  #         clients = builtins.attrNames (
  #           builtins.removeAttrs (config.local.wg.hosts) [ server ]
  #         );

  #       in
  #       {
  #         ${server}.peers = clients;
  #       } // lib.genAttrs clients (client: { peers = [ server ]; });
  #   }
  local.wg = {
    enable = true;
    interface = "wg1";
    hosts = {
      "void" = {
        n = 1;
        publicKey = "nrGGXjdqz0jLrY733wi/sHUhIFtN/GFzrYZdZaaU118=";

        server = {
          enable = true;
          externalInterface = "eno1";
        };

        peers = [
          "getsuga"
          "epictetus"
          "windows"
        ];

      };
      "getsuga" = {
        n = 2;
        publicKey = "a7Xk7X+OVgqy+1kPrtI0TeJF/IgtuNGP7ouQreGJMC0=";
        peers = [ "void" ];
      };
      # phone
      "epictetus" = {
        n = 3;
        publicKey = "JD1D0OnHfhz/ggEhek7atSv52GyPYR3cBP3Irq/ORX8=";
        peers = [ "void" ];
      };
      # windows
      "windows" = {
        n = 4;
        publicKey = "DhL19XircLfNf4OEO+YBOWxjLcm6tPJcrPsQk2Qwv2c=";
        peers = [ "void" ];
      };
    };
  };
}
# ];
