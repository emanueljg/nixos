{ pkgs, lib, ... }: {
  environment.systemPackages =
    let
      pkg =
        pkgs.symlinkJoin {
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

            wrapProgram $out/bin/nnn \
              --prefix NNN_PLUG : "p:$out/share/plugins/preview-tui" \
              --add-flags '-aP p'
          '';
        };
    in
    [ pkg ];
  environment.shellAliases."n" = "nnn";
}
