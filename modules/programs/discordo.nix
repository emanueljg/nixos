{ config, pkgs, discordo, ... }:

let secret = "discordo-token"; in {

  sops.secrets.${secret} = {
    sopsFile = ../../secrets/${secret}.yaml;
    mode = "0440";
    owner = "ejg";
    group = "wheel";
  };

  my.home.packages = let
    pkg = discordo.defaultPackage.${pkgs.system};
  in [
    pkg 
    (
      pkgs.writeShellScriptBin "dc" ''
        ${pkg}/bin/discordo \
          --token $(cat ${config.sops.secrets.${secret}.path})
      ''
    )
  ];

}
