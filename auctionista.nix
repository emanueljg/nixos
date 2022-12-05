{ config, auctionista, ... }:

{
  imports = [
    auctionista.nixosModules.default
  ];

  services.auctionista = {
    enable = true;
  };
}
