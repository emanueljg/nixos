{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.local.programs.qutebrowser;

  pythonize =
    v:
    if v == null then
      "None"
    else if builtins.isBool v then
      (if v then "True" else "False")
    else if builtins.isString v then
      ''"${v}"''
    else if builtins.isList v then
      "[${lib.concatStringsSep ", " (map pythonize v)}]"
    else
      builtins.toString v;
  formatDictLine =
    o: n: v:
    ''${o}['${n}'] = "${v}"'';

  formatKeyBindings =
    m: b:
    let
      formatKeyBinding =
        m: k: c:
        if c == null then
          ''config.unbind("${k}", mode="${m}")''
        else
          ''config.bind("${k}", "${lib.escape [ ''"'' ] c}", mode="${m}")'';
    in
    lib.concatStringsSep "\n" (lib.mapAttrsToList (formatKeyBinding m) b);

  formatQuickmarks = n: s: "${n} ${s}";

  # flattenSettings attrset -> [ [ <opt_path> <opt_value>] ]
  flattenSettings =
    x:
    lib.collect (x: !builtins.isAttrs x) (
      lib.mapAttrsRecursive (path: value: [
        (lib.concatStringsSep "." path)
        value
      ]) x
    );

  configSet = l: "config.set(${lib.concatStringsSep ", " (map pythonize l)})";
in
{
  options.local.programs.qutebrowser = {
    enable = lib.mkEnableOption "qutebrowser";

    package = lib.mkPackageOption pkgs "qutebrowser" { };

    searchEngines = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
    };

    keyBindings = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf (nullOr (separatedString " ;; ")));
      default = { };
    };

    quickmarks = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
    };

    greasemonkey = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
    };

    stylesheets = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = name;
              };
              includes = lib.mkOption {
                default = [ ];
                type = with lib.types; listOf str;
              };
              excludes = lib.mkOption {
                default = [ ];
                type = with lib.types; listOf str;
              };
              css = lib.mkOption {
                type = lib.types.str;
              };
            };
          }
        )
      );
    };
  };

  config =
    let
      qutebrowserConfig = lib.concatStringsSep "\n" (
        [ "config.load_autoconfig(False)" ]
        ++ map configSet (flattenSettings cfg.settings)
        ++ lib.mapAttrsToList (formatDictLine "c.url.searchengines") cfg.searchEngines
        ++ lib.mapAttrsToList formatKeyBindings cfg.keyBindings
      );

      quickmarksFile = lib.concatStringsSep "\n" (lib.mapAttrsToList formatQuickmarks cfg.quickmarks);

      greasemonkeyDir = lib.optionals (
        cfg.greasemonkey != [ ]
      ) pkgs.linkFarmFromDrvs "greasemonkey-userscripts" cfg.greasemonkey;
    in
    lib.mkIf cfg.enable {
      local.programs.qutebrowser.greasemonkey =
        let
          mkUserscript =
            stylesheet:
            let
              includes' = lib.concatMapStringsSep "\n" (include: "// @include    ${include}") stylesheet.includes;
              excludes' = lib.concatMapStringsSep "\n" (exclude: "// @exclude    ${exclude}") stylesheet.excludes;
            in
            (pkgs.writeTextFile {
              name = "qb-grease-stylesheet-${stylesheet.name}.js";
              text = ''
                // ==UserScript==
                // @name    Userstyle (${stylesheet.name})
                ${includes'}
                ${excludes'}
                // ==/UserScript==
                GM_addStyle(`${stylesheet.css}`)
              '';
            });
        in
        builtins.map mkUserscript (builtins.attrValues cfg.stylesheets);
      local.wrap.wraps."qutebrowser" = {
        pkg = cfg.package;
        systemPackages = true;
        bins."qutebrowser".envs."XDG_CONFIG_HOME".paths = {
          "qutebrowser/config.py" = qutebrowserConfig;
          "qutebrowser/quickmarks" = quickmarksFile;
          "qutebrowser/bookmarks/urls" = "";
          "qutebrowser/greasemonkey" = greasemonkeyDir;
        };
      };
    };
}
