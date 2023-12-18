{
  config,
  pkgs,
  lib,
  ...
}: {
  my.nixpkgs.overlays = let
    # custom variables
    activeDownloadFormat = "({index}) {name} | {total} | {perc:<2}% | {speed:<10}";
    doneDownloadFormat = "({index}) {name} | {total} | {perc:<2}% | Finished!";

    # inferred
    setActiveDownloadsFormat = lib.strings.concatStrings [
      # This format is defined over two lines in the original python class,
      # requiring two sed commands to fully change it.

      ''cat ''
      ''"qutebrowser/browser/downloads.py"''

      " | "

      ''sed "s''
      ''/{index}: {name} \[{speed:>10}|{remaining:>5}|{perc:>2}%|''
      ''/${activeDownloadFormat}''
      ''/g"''

      " | "

      ''sed "s''
      ''/{down}\/{total}\]''
      ''/'' # delete
      ''/g"''

      # Set done downloads format
      # sed "s/{index}: {name} \[{perc:>2}%|{total}\]/FOUND2/g"

      " | "

      ''sed "s''
      ''/{index}: {name} \[{perc:>2}%|{total}\]''
      ''/${doneDownloadFormat}''
      ''/g"''

      " > "

      ''"$out/lib/python3.9/site-packages/qutebrowser/browser/downloads.py"''
    ];
  in [
    (
      self: super: {
        qutebrowser = super.qutebrowser.overrideAttrs (oldAttrs: rec {
          postInstall =
            oldAttrs.postInstall
            + ''
              ${setActiveDownloadsFormat}
            '';
        });
      }
    )
  ];
}
