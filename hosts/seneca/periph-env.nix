{ config, lib, pkgs, ... }:

with lib;

let 
  inherit (import ../../parts/helpers.nix { inherit lib; })
    doRecursiveUpdates
  ;

  inherit (import ../../parts/home/programs/i3/helpers.nix { inherit config; inherit lib; })
    genWorkspaceOutputs
  ;

  cfg = config.periph-env;
in {
  imports = [
    ../../parts/home/hm.nix
    ./qjoypad.nix
  ];

  options.periph-env = {
    enable = mkEnableOption "Per-specialisation computer peripherals configuration";

    env = mkOption {
      type = types.str;
      default = "";
    };

    # inferred
    screens = mkOption {
      type = types.attrs;
    };

  };

  config = mkIf cfg.enable {
    specialisation = 
      lib.attrsets.genAttrs 
        [ "mobile" "docked" "tv" ] 
        (spec: { configuration = { system.nixos.tags = [ "${spec}" ]; periph-env.env = "${spec}"; };})
    ;

    # infer screen names from set env
    periph-env.screens =
      let
        modesetting-names = {
          laptop = "eDP-1";
            dock = {
              center-HDMI = "DVI-I-2-2";
              right-DP = "DVI-I-1-1";
            };
          tv = "HDMI-1";
        };
    
        intel-names = {
          laptop = "eDP1";
          tv = "HDMI1";
        };
      in
        if cfg.env == "tv" then 
          attrsets.recursiveUpdate modesetting-names intel-names
        else
          modesetting-names
    ;

    # set external options
    services.xserver = 
      if cfg.env == "tv" then {
        videoDrivers = [ "intel" ];
        deviceSection = ''
          Option "TearFree" "true"
        '';
      } else let ms = [ "modesetting" ]; in {
        videoDrivers = 
          if cfg.env == "mobile" then 
            ms 
          else 
            ms ++ [ "displaylink" ] 
        ;
      }
    ;

    # first of all, configure qjoypad correctly
    qjoypad = {
      enable = cfg.env == "tv";
      defaultLayout = "main";
      layouts = {
        "main" = {
          isDefault = true;
          lyt = {
            "Joystick 1" = {
              "Axis 1" = [ "gradient" "maxSpeed 3" "mouse+h" ];
              "Axis 2" = [ "gradient" "maxSpeed 3" "mouse+v" ];
              "Axis 3" = [ "gradient" "+key 0" "-key 0" ];
              "Axis 4" = [ "gradient" "+key 0" "-key 0" ];
              "Axis 7" = [ "+key 114" "-key 113" ];
              "Axis 8" = [ "+key 116" "-key 111" ];
              "Button 1" = [ "key 0" ];
              "Button 3" = [ "key 0" ];
              "Button 4" = [ "mouse 1" ];
            };
          };
        };
      };
    };
    
    my = with cfg.screens; {

      programs.autorandr = 
        let
          fingerprint = { 
            ${laptop} = "00ffffffffffff0009e5c00600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe003138364743804e5631324e353100000000000041119e001000000a010a202000d6";
            ${dock.center-HDMI} = "00ffffffffffff0006b3a325010101011a1e010380361e78ea4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028781e8c1e000a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533136373535320a012d020329f14b900504030201111213141f230907078301000067030c0010000044681a000001012878008a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001a0000000000000000000000000000000000000000000000000000000000000000d7";
            ${dock.right-DP} = "00ffffffffffff0006b3a42501010101191e0104a5361e783b4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028a5c3c329010a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131323037380a01a8020318f14b900504030201111213141f2309070783010000a49c80a07038594030203500202f2100001a8a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000af";
            ${tv} = "00ffffffffffff0006b3a32501010101191e010380361e78ea4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028781e8c1e000a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131313737320a0135020329f14b900504030201111213141f230907078301000067030c0010000044681a000001012878008a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001a0000000000000000000000000000000000000000000000000000000000000000d7";
          };
          base-config = {
            enable = true;
            mode = "1920x1080";
            rate = "60.00";
          };
        in {
          enable = true;
          profiles = {
            "mobile" = {
              fingerprint.${laptop} = fingerprint.${laptop};
              config.${laptop} = base-config;
            };
            
            "docked" = {
              inherit fingerprint;
              config = doRecursiveUpdates base-config {
                ${dock.center-HDMI} = {
                  primary = true;
                  position = "0x0";
                };

                ${dock.right-DP} = {
                  position = "1920x0";
                };

                ${laptop} = {
                  position = "3840x0";
                };
              };
            };

            "tv" = {
              fingerprint.${laptop} = fingerprint.${laptop};
              fingerprint.${tv} = fingerprint.${tv};

              config = doRecursiveUpdates base-config {
                ${tv} = { 
                  position = "0x0";
                };

                ${laptop} = {
                  position = "0x1080";
                };
              };
            };
          };
        }
      ;

      xsession = {
        # TODO fix qjoypad bullshit
        initExtra = strings.optionalString (cfg.env == "docked") (''
          xrandr --setprovideroutputsource 1 0; 
          xrandr --setprovideroutputsource 2 0;
        '') + ''
          autorandr -l mobile
        '' + strings.optionalString (cfg.env != "mobile") (''
          autorandr -l ${cfg.env}
        '') + strings.optionalString (cfg.env == "tv") (''
          qjoypad &
          bluetoothctl connect 5C:EB:68:79:BA:6F &
        '')
        ;

        windowManager.i3.config.workspaceOutputAssign = genWorkspaceOutputs (
          if cfg.env == "docked" then {
            ${dock.center-HDMI} = range 1 5;
            ${dock.right-DP} = range 6 10;
          } else if cfg.env == "tv" then {
            ${tv} = [ 1 ];
            ${laptop} = range 2 10;
          } else {  # assume mobile
            ${laptop} = range 1 10;
          }
        );
      };
    };
  };
}
  
