{ config, filmvisarna, ... }:

{
  imports = [
    filmvisarna.nixosModules.default
  ];

  services.filmvisarna = {
    enable = false;
  };

}
