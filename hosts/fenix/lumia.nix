{ pkgs, ... }: {
  systemd.services."lumia" = {
    serviceConfig = { User = "ejg"; Group = "users"; };
    path = with pkgs; [ 
      git 
      bash 
      nodejs-18_x
    ];
    script = ''
      export ROOT_DIR=$(mktemp -d)

      git clone https://github.com/emanueljg/demo-deploy-action $ROOT_DIR
      cd $ROOT_DIR
      npm ci
      node server.js
    '';
  };
}
