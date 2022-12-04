{ config, pkgs, ... }:

{
  services.mysql = {
   package = pkgs.mysql80;
   enable = true;
  };
}
