{ pkgs, config, lib, ... }:
let
  settings = {
    term = lib.getExe config.local.programs.kitty.package;
    key_left = "h";
    key_down = "j";
    key_up = "k";
    key_right = "l";
  };

in
{
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "wofi";
      paths = [ pkgs.wofi ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/wofi \
          --set 'XDG_CONFIG_DIR' ${
            pkgs.symlinkJoin {
              name = "wofi-confdir";
              paths = [(
                pkgs.writeTextDir "wofi/config"
                  (lib.generators.toKeyValue { } settings)
              )];
            }
          }
      '';
    })
  ];
}
