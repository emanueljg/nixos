{ config, pkgs, discordo, ... }:

let secret = "discordo-token"; in {

  sops.secrets.${secret} = {
    sopsFile = ../../secrets/${secret}.yaml;
    mode = "0440";
    owner = "ejg";
    group = "wheel";
  };

  my.home.packages = [(
    pkgs.writeShellScriptBin "discordo" ''
      ${discordo.defaultPackage.${pkgs.system}}/bin/discordo \
        --token $(cat ${config.sops.secrets.${secret}.path})
    ''
  )];

}
