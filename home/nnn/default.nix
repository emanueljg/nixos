{ pkgs, lib, ... }: {
  programs.nnn =
    let
      # poppler_utils with all utilities removed except for pdftoppm 
      poppler_utils' = pkgs.poppler_utils.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + (
          lib.concatMapStringsSep
            "\n"
            (program: "rm $out/bin/${program}")
            [
              "pdfattach"
              "pdfdetach"
              "pdffonts"
              "pdfimages"
              "pdfinfo"
              "pdfseparate"
              "pdfsig"
              "pdftocairo"
              "pdftohtml"
              "pdftops"
              "pdftotext"
              "pdfunite"
            ]
        );
      });
      pkg = pkgs.nnn.overrideAttrs
        (old: {
          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/share/plugins/preview-tui \
              --prefix PATH : ${lib.makeBinPath [ poppler_utils' ]}
          '';
        });
    in
    {
      enable = true;
      package = pkg;
      plugins = {
        src = "${pkg}/share/plugins";
        mappings = {
          p = "preview-tui";
        };
      };
    };
  home.shellAliases."n" = "nnn -aP p";
}
