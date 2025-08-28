{ pkgs, lib, ... }:
{
  environment.systemPackages =
    let
      pkg = pkgs.symlinkJoin {
        name = "nnn";
        buildInputs = [
          pkgs.makeWrapper
        ];
        paths = [
          pkgs.nnn
        ];
        postBuild = ''
          wrapProgram $out/share/plugins/preview-tui \
            --prefix PATH : ${lib.makeBinPath [ pkgs.poppler_utils ]}

          mkdir -p $out/HOME/nnn/{bookmarks,mounts,sessions}
          ln -s $out/share/plugins $out/HOME/nnn

          wrapProgram $out/bin/nnn \
            --set XDG_CONFIG_HOME $out/HOME \
            --prefix NNN_PLUG : "p:preview-tui" \
            --add-flags '-aP p'
        '';
      };
    in
    [ pkg ];
  environment.shellAliases."n" = "nnn";
}
