{ lib, ... }:
{
  options.local.lib = {
    toHyprConf = lib.mkOption {
      type = with lib.types; functionTo str;
      readOnly = true;
      default =
        {
          attrs,
          indentLevel ? 0,
          importantPrefixes ? [ "$" ],
        }:
        let
          inherit (lib)
            all
            concatMapStringsSep
            concatStrings
            concatStringsSep
            filterAttrs
            foldl
            generators
            hasPrefix
            isAttrs
            isList
            mapAttrsToList
            replicate
            ;

          initialIndent = concatStrings (replicate indentLevel "  ");

          toHyprconf' =
            indent: attrs:
            let
              sections = filterAttrs (n: v: isAttrs v || (isList v && all isAttrs v)) attrs;

              mkSection =
                n: attrs:
                if lib.isList attrs then
                  (concatMapStringsSep "\n" (a: mkSection n a) attrs)
                else
                  ''
                    ${indent}${n} {
                    ${toHyprconf' "  ${indent}" attrs}${indent}}
                  '';

              mkFields = generators.toKeyValue {
                listsAsDuplicateKeys = true;
                inherit indent;
              };

              allFields = filterAttrs (n: v: !(isAttrs v || (isList v && all isAttrs v))) attrs;

              isImportantField =
                n: _: foldl (acc: prev: if hasPrefix prev n then true else acc) false importantPrefixes;

              importantFields = filterAttrs isImportantField allFields;

              fields = builtins.removeAttrs allFields (mapAttrsToList (n: _: n) importantFields);
            in
            mkFields importantFields
            + concatStringsSep "\n" (mapAttrsToList mkSection sections)
            + mkFields fields;
        in
        toHyprconf' initialIndent attrs;
    };
    fontType = lib.mkOption {
      readOnly = true;
      type = lib.types.anything;
      default = lib.types.submodule {
        options = {
          package = lib.mkOption {
            type = with lib.types; nullOr package;
            default = null;
            example = lib.literalExpression "pkgs.dejavu_fonts";
            description = ''
              Package providing the font. This package will be installed
              to your profile. If `null` then the font
              is assumed to already be available in your profile.
            '';
          };

          name = lib.mkOption {
            type = lib.types.str;
            example = "DejaVu Sans";
            description = ''
              The family name of the font within the package.
            '';
          };

          size = lib.mkOption {
            type = with lib.types; nullOr number;
            default = null;
            example = "8";
            description = ''
              The size of the font.
            '';
          };
        };
      };
    };
  };

}
