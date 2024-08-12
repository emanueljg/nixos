{ config, lib, pkgs, ... }: {
  options.programs.qutebrowser.stylesheets = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
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
    }));
  };

  config = {
    programs.qutebrowser.greasemonkey =
      let
        mkUserscript = stylesheet:
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
      builtins.map mkUserscript (builtins.attrValues config.programs.qutebrowser.stylesheets);
  };
}
