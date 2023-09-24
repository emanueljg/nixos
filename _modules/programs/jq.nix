{ config, pkgs, ... }:

{
  my.home.packages = with pkgs; [ jq ];
}
