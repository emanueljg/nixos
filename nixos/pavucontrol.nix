{ pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.pavucontrol ];
    shellAliases = {
      "pavu" = "pavucontrol";
    };
  };
}
