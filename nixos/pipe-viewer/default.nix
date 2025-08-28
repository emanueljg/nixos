{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment = {
    systemPackages = [ pkgs.pipe-viewer ];
    shellAliases =
      let
        conf = pkgs.replaceVars ./pipe-viewer.conf {
          # lib stuff
          PERL = pkgs.perl;
          PERL_TEST_POD = pkgs.perl540Packages.TestPod;
          PERL_MODULE_BUILD = pkgs.perl540Packages.ModuleBuild;
          PIPE_VIEWER = pkgs.pipe-viewer;

          MPV = lib.getExe pkgs.mpv;
          FFMPEG_CMD = lib.getExe pkgs.ffmpeg;
          WGET = lib.getExe pkgs.wget;
          YT_DLP = lib.getExe config.local.programs.yt-dlp.package;
        };

      in
      {
        "y" = "pipe-viewer --config ${conf}";
        "y-nl" = "y --order=upload_date 'the library of letourneau bits and banter'";
      };
  };
}
