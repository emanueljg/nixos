{ pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.ani-cli ];
    shellAliases = {
      "ani" = "ani-cli";
    };
  };
}
