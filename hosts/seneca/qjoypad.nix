{ config, lib, pkgs, ... }:

with lib; let
  inherit (builtins)
    mapAttrs
    attrValues
    attrNames
    isString
  ;

  inherit (strings)
    concatStringsSep
  ;

  inherit (lib.attrsets) 
    nameValuePair
  ;

  cfg = config.qjoypad;
in

{
  imports = [
    ../../parts/home/hm.nix
  ];

  options.qjoypad = {
    enable = mkEnableOption "foo";

    layouts = mkOption {
      type = types.attrs;
    };

    defaultLayout = mkOption {
      type = types.str;
    };
  };

  config = 
    let
      defaultLayout = 
        (findSingle 
          isString
          "none"
          "multiple"
          (attrNames
            (filterAttrs 
              (name: layout: layout.isDefault)
              cfg.layouts
              )
            )
          )
      ;
    in
      mkIf cfg.enable {
      assertions = [
        { 
          assertion = defaultLayout != "none";
          message = "No layout is set as default! Set a layout as default using qjoypad.layouts.<name>.isDefault = true;";
        }

        {
          assertion = defaultLayout != "multiple";
          message = "More than one layout is set as default!";
        }
      ];
      
      my = {
        # enable the package
        home.packages = with pkgs; [ qjoypad ];
        
        # generate the .lyt layout files...
        home.file = 
          let
            dir = ".qjoypad3";

            mapAttrValues = f: as: 
              attrValues (mapAttrs f as)
            ;

            # lol
            mapAttrValuesStringSepConcat = sep: f: as:
              concatStringsSep
                sep
                (mapAttrValues f as)
            ;

            generateLayout = layout: ''
                # QJoyPad 4.1 Layout File
                # Generated by qjoypad.nix with home-manager

              '' + generateJoysticks layout.lyt
            ;

            generateJoysticks = lyt:
              mapAttrValuesStringSepConcat 
                "\n\n"
                (joystick: axes: "${joystick} {\n" + generateControls axes + "\n}")
                lyt
            ;

            generateControls = js:
              mapAttrValuesStringSepConcat
                "\n"
                (axis: flags: "        ${axis}: ${concatStringsSep ", " flags}")
                js
            ;
          in
            (mapAttrs'
              (name: layout: 
                nameValuePair 
                  ("${dir}/${name}.lyt")
                  ({ text = generateLayout layout; })
                )
              cfg.layouts
              )
            //
            # ...and update with the layout file that sets the default .lyt
            { "${dir}/layout" = { text = defaultLayout; }; }
          
        ;

      };
  };
}