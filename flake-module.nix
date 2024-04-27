{ inputs, lib, self, flake-parts-lib, config, ... }: {
  options.nixcfg =
    let
      mkModuleSetOption =
        { output
        , nixpkgsDefault
        , cfgFunction
        , extraOptions ? { }
        }:
        lib.mkOption {
          default = { };
          type = lib.types.submodule ({ ... }@submod: {
            options = {
              enable = lib.mkOption {
                default = true;
                type = lib.types.bool;
              };

              nixpkgs = lib.mkOption {
                default = nixpkgsDefault;
              };

              specialArgs = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = submod.specialArgs;
              };

              path = lib.mkOption {
                type = lib.types.str;
                default = "${self}/${output}";
              };

              _cfgFunction = lib.mkOption {
                readOnly = true;
                internal = true;
                type = lib.types.unspecified;
                default = cfgFunction;
              };

              _haumeaModules = lib.mkOption {
                readOnly = true;
                internal = true;
                type = with lib.types; lazyAttrsOf unspecified;
                default =
                  let
                    mods = inputs.haumea.lib.load {
                      src = submod.config.path;
                      loader = inputs.haumea.lib.loaders.verbatim;
                      # transformer = inputs.haumea.lib.transformers.liftDefault;
                    };
                  in
                  mods;
              };
            };
          });
        };


      mkCfgType =
        { category
        , extraOptions ? { }
        }: lib.types.attrsOf (lib.types.submodule
          ({ name, ... }@submod:
          let
            mkModOption = output: lib.mkOption {
              readOnly = true;
              internal = true;
              default =
                let
                  parentModules = builtins.map (par: par."_${output}Modules") submod.config._args.parents;
                in
                lib.flatten [ parentModules submod.config._args.${output} ];
            };

          in
          {
            options = {
              system = lib.mkOption {
                type = lib.types.str;
                default = "x86_64-linux";
              };
              specialArgs = lib.mkOption {
                type = lib.types.attrsOf lib.types.unspecified;
                default = { };
              };
              skippedImports = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              path = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default =
                  let
                    noSuffixPath = "${self}/${category}/${name}";
                    suffix = if builtins.pathExists noSuffixPath then "" else ".nix";
                  in
                  noSuffixPath + suffix;
              };
              _args = lib.mkOption {
                readOnly = true;
                internal = true;
                default = import submod.config.path {
                  inherit (config.nixcfg) hosts blueprints;
                  nixos = config.nixcfg.nixos._haumeaModules;
                  home = config.nixcfg.home._haumeaModules;
                };
                type = lib.types.submodule {
                  options = {
                    parents = lib.mkOption {
                      type = lib.types.listOf lib.types.unspecified;
                    };
                    nixos = lib.mkOption {
                      type = lib.types.listOf lib.types.unspecified;
                    };
                    home = lib.mkOption {
                      type = lib.types.listOf lib.types.unspecified;
                    };

                  };
                };
              };

              _familySpecialArgs = lib.mkOption {
                readOnly = true;
                internal = true;
                type = with lib.types; attrsOf unspecified;
                default = (lib.foldr
                  (x: y:
                    x._familySpecialArgs
                    //
                    y
                  )
                  submod.config.specialArgs
                  submod.config._args.parents
                );
              };

              _nixosModules =
                mkModOption "nixos";
              _homeModules = mkModOption "home";


            };
          }));
    in
    {
      enable = lib.mkEnableOption "nixcfg";
      specialArgs = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      nixos = mkModuleSetOption {
        output = "nixos";
        nixpkgsDefault = inputs.nixpkgs;
        cfgFunction = hostname: configuration: inputs.nixpkgs.lib.nixosSystem {
          inherit (configuration) system;
          specialArgs =
            let
              debug =
                config.nixcfg.specialArgs //
                config.nixcfg.nixos.specialArgs //
                (configuration._familySpecialArgs) // {
                  nixos = configuration.nixos._moduleAttrset;
                };
            in
            builtins.trace debug debug;
          modules = configuration._nixosModules;
        };
      };

      home = mkModuleSetOption {
        output = "home";
        nixpkgsDefault = inputs.nixos-unstable;
        cfgFunction = hostname: configuration: inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = config.nixcfg.home.nixpkgs.legacyPackages.${configuration.system};
          modules = configuration._homeModules;
          extraSpecialArgs =
            config.nixcfg.specialArgs //
            config.nixcfg.home.specialArgs //
            configuration.familySpecialArgs // {
              home = configuration.home._moduleAttrset;
            };
        };
      };


      blueprints = lib.mkOption {
        type = mkCfgType { category = "blueprints"; };
      };
      hosts = lib.mkOption {
        type = mkCfgType { category = "hosts"; };
      };
    };

  config.flake =
    let
      mkCfgOutputs = output: builtins.mapAttrs (hostname: host: config.nixcfg.${output}._cfgFunction hostname host) config.nixcfg.hosts;
    in
    lib.mkIf config.nixcfg.enable {
      nixosConfigurations = mkCfgOutputs "nixos";
      homeConfigurations = mkCfgOutputs "home";
    };
}



