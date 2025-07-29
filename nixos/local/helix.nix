{ config, pkgs, lib, ... }:
let
  settingsFormat = pkgs.formats.toml { };
  cfg = config.local.programs.helix;
in
{
  options.local.programs.helix = {
    enable = lib.mkEnableOption "helix";
    package = lib.mkPackageOption pkgs "helix" { };
    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
    };
    languages = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
    };
  };

  config = {
    environment = lib.mkIf cfg.enable {
      sessionVariables =
        let
          EDITOR = "hx";
        in
        {
          inherit EDITOR;
          SUDO_EDITOR = EDITOR;
          VISUAL = EDITOR;
        };
      systemPackages =
        let
          tomlFormat = pkgs.formats.toml { };
          confdir = pkgs.runCommand "helix-confdir" { } ''
            mkdir -p $out/helix
            ln -s "${tomlFormat.generate "helix-config.toml" cfg.settings}" $out/helix/config.toml
            ln -s "${tomlFormat.generate "helix-languages.toml" cfg.languages}" $out/helix/languages.toml
          '';
          pkg = pkgs.symlinkJoin {
            name = "hx-confed";
            buildInputs = [
              pkgs.makeWrapper
            ];
            paths = [
              cfg.package
            ];
            postBuild = ''
              wrapProgram $out/bin/hx \
                --set 'XDG_CONFIG_HOME' '${confdir}'
            '';
          };
        in
        [ pkg ];
    };
  };
}
