{ config, lib, pkgs, ... }:
let
  cfg = config.local.wrap;
  wrapperArgType = wraps: lib.types.attrsOf (lib.types.submodule ({ name, ... }@args: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        default = name;
      };
      paths = lib.mkOption {
        default = { };
        type = with lib.types; attrsOf anything;
      };
      path = lib.mkOption {
        default = null;
        type = with lib.types; nullOr (either str path);
      };
      finalPath = lib.mkOption {
        readOnly = true;
        type = with lib.types; nullOr path;
        default =
          if builtins.isString args.config.path then
            (pkgs.writeText name args.config.path)
          else
            args.config.path;
      };
      finalPathDrvs = lib.mkOption {
        type = with lib.types; attrsOf package;
        readOnly = true;
        default = builtins.mapAttrs
          (name: value:
            if value == null then
              null
            else if builtins.isString value then
              (pkgs.writeTextDir name value)
            else
              (pkgs.runCommand (builtins.baseNameOf name) { } ''
                d="$out/$(dirname ${name})"
                mkdir -p "$d"
                ln -s "${value}" "$d/$(basename ${name})"                                
              '')
          )
          args.config.paths;
      };
      postBuild = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
      finalDir = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        default = pkgs.symlinkJoin {
          name = "wrapped-${wraps.config.name}-${args.config.name}";
          paths = builtins.filter (e: !(builtins.isNull e)) (builtins.attrValues args.config.finalPathDrvs);
          postBuild = args.config.postBuild;
        };
      };
      finalOutput = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        default = if args.config.finalPath != null then args.config.finalPath else args.config.finalDir;
      };
    };
  }));
in
{

  options.local.wrap = {
    enable = lib.mkEnableOption "";
    wraps = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }@wraps: {
        options = {
          enable = lib.mkEnableOption "";
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
          };
          pkg = lib.mkOption {
            type = lib.types.package;
          };
          bins = lib.mkOption {
            default = { };
            type = lib.types.attrsOf (lib.types.submodule ({ name, ... }@bins: {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                };
                envs = lib.mkOption {
                  default = { };
                  type = wrapperArgType wraps;
                };
                flags = lib.mkOption {
                  default = { };
                  type = wrapperArgType wraps;
                };
                extraWrapArgs = lib.mkOption {
                  type = lib.types.lines;
                  default = "";
                };
                finalWrapperText = lib.mkOption {
                  type = lib.types.lines;
                  readOnly = true;
                  default = ''
                    wrapProgram "$out/bin/${bins.config.name}" \
                    ${lib.concatMapAttrsStringSep "\n"
                      (_: env: ''  --set ${env.name} ${env.finalOutput} \'')
                      bins.config.envs
                    }${lib.concatMapAttrsStringSep "\n"
                      (_: flag: ''  --add-flags '${flag.name} ${flag.finalOutput}' \'')
                      bins.config.flags
                    }${bins.config.extraWrapArgs}
                  '';
                };
              };
            }));
          };
          systemPackages = lib.mkEnableOption "";
          preWrap = lib.mkOption {
            type = lib.types.lines;
            default = "";
          };
          postWrap = lib.mkOption {
            type = lib.types.lines;
            default = "";
          };
          override = lib.mkOption {
            type = with lib.types; oneOf [
              (attrsOf anything)
              (functionTo (attrsOf anything))
            ];
            default = { };
          };
          overrideAttrs = lib.mkOption {
            type = with lib.types; oneOf [
              (attrsOf anything)
              (functionTo (attrsOf anything))
              (functionTo (functionTo (attrsOf anything)))
            ];
            default = { };
          };
          finalPackage = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            default = lib.pipe
              (pkgs.callPackage
                (
                  { symlinkJoin, makeWrapper, lib, wrappedPkg ? wraps.config.pkg }:
                  (symlinkJoin
                    {
                      inherit (wraps.config) name;
                      buildInputs = [
                        makeWrapper
                      ];
                      paths = [
                        wrappedPkg
                      ];
                      passthru.wrapped = wrappedPkg;
                      postBuild = ''
                        ${wraps.config.preWrap}

                        ${lib.concatMapAttrsStringSep
                          "\n"
                          (_: bin: bin.finalWrapperText)
                          wraps.config.bins
                        }

                        ${wraps.config.postWrap}
                      '';
                    } // (lib.optionalAttrs (wrappedPkg ? meta.mainProgram) {
                    meta = { inherit (wrappedPkg) mainProgram; };
                  })
                  )
                )
                { }) [
              (pkg: pkg.overrideAttrs (wraps.config.overrideAttrs))
              (pkg: pkg.override (wraps.config.override))
            ];
          };

        };
      }));
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.pipe cfg.wraps [
      builtins.attrValues
      (builtins.filter (wrapper: wrapper.systemPackages))
      (map (wrapper: wrapper.finalPackage))
    ];
  };
}
