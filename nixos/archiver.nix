{
  nixosModules,
  other,
  pkgs,
  ...
}:
let
  inherit (other.archiver-lib)
    writeArchiveScript
    mapLines
    ;
in
{
  imports = [
    nixosModules.archiver
  ];
  services.archiver = {
    enable = true;
    jobs =
      let
        workDir = "/mnt/data/dl/Conan O'Brien Needs a Friend";
        defaultArgs = ''
          --write-link \
          --write-description \
          --write-thumbnail \
          --convert-thumbnails 'png' \
          --embed-thumbnail \
          --write-subs \
          --write-comments \
          --write-info-json \
          --embed-metadata \
          --merge-output-format 'mkv' \
        '';
        # --cookies-from-browser 'firefox' \
      in
      {
        "conaf-audio" = {
          inherit workDir;
          script = writeArchiveScript {
            name = "archive-conaf-audio";
            url = "https://feeds.simplecast.com/dHoohVNH";
            downloadDir = "Audio";
            args =
              let
                extraMetadata = rec {
                  album = "Conan O'Brien Needs a Friend";
                  album_artist = "Team Coco & Earwolf";
                  artist = album_artist;
                };
                addMetadataParse = key: ''--parse-metadata "${extraMetadata.${key}}:%(${key})s"'';
              in
              defaultArgs
              + ''
                --playlist-reverse \
                --playlist-items "::-1" \
                --compat-options playlist-index \
                --parse-metadata "%(playlist_index)s:%(track_number)s" \
                --break-on-existing \
                ${addMetadataParse "album"} \
                ${addMetadataParse "album_artist"} \
                ${addMetadataParse "artist"} \
                --ppa "Metadata+ffmpeg:-id3v2_version 3" \
                -o '[%(playlist_index)s][%(upload_date>%Y-%m-%d)s] %(title)s [%(id)s]/%(title)s.%(ext)s' \
              '';
          };
        };
        "conaf-video" = {
          inherit workDir;
          script = writeArchiveScript {
            name = "archive-conaf-video";
            url = "https://www.youtube.com/playlist?list=PLVL8S3lUHf0Te3TvS37LaF6dk4rhkc2gg";
            downloadDir = "Video";
            forceDownloadSuccess = true;
            args = defaultArgs + ''
              -o '[%(upload_date>%Y-%m-%d)s] %(title)s [%(id)s]/%(title)s.%(ext)s' \
            '';
          };
        };
      };
  };
}
#   archiveCONAFVideo = };
#   archiveCONAF =
#     let
#       scripts = [ archiveCONAFVideo archiveCONAFAudio ];
#     in
#     utils.writeCompatShellApplication {
#       name = "archive-conaf";
#       runtimeInputs = scripts;
#       text = utils.mapLines (script: script.name) scripts;
#       compatText = utils.mapLines (script: "./${script.name}.sh") scripts;
#     };
#   default = archiveCONAF;
#   writeCompatScripts = pkgs.writeShellApplication {
#     name = "write-conaf-scripts";
#     text =
#       let
#         scripts = [ archiveCONAFAudio archiveCONAFVideo archiveCONAF ];
#       in
#       utils.mapLines (script: "install ${script.passthru.originalText} ${script.name}.sh") scripts;
#   };

# }
