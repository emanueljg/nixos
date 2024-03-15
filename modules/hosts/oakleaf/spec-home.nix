{ config, lib, pkgs, ... }:
{

  imports = [ ./. ];

  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';
  nixpkgs.overlays = [
    (final: prev: {
      displaylink = prev.displaylink.overrideAttrs (_: {
        src = final.fetchurl {
          url = "https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip";
          name = "displaylink-580.zip";
          hash = "sha256-IsVS6tRIyA2ejdSKhCu1ERhNB6dBgKx2vYndFE3dqBY=";
        };
      });
    })
  ];

  my.programs.autorandr = {
    enable = true;
    profiles = rec {
      default = {
        fingerprint = {
          # computer screen
          "eDP-1" = "00ffffffffffff0026cf7f8500000000001d0104a51d11780ade50a3544c99260f505400000001010101010101010101010101010101383680a07038204018303c0026a510000019000000fe00523133334e564643205237200a00000003000326a2042c5c120808af00000000000003001951ff64a0f4120830c20101000011";
          # left screen (vertical)
          "DVI-I-2-2" = "00ffffffffffff0006b3a42501010101191e0104a5361e783b4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028a5c3c329010a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131313737320a01a8020318f14b900504030201111213141f2309070783010000a49c80a07038594030203500202f2100001a8a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000af";
          # center screen
          "DVI-I-1-1" = "00ffffffffffff0006b3a42501010101191e0104a5361e783b4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028a5c3c329010a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131323037380a01a8020318f14b900504030201111213141f2309070783010000a49c80a07038594030203500202f2100001a8a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000af";
          # right screen
          "DP-2" = "00ffffffffffff0006b3a325010101011a1e010380361e78ea4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028781e8c1e000a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533136373535320a012d020329f14b900504030201111213141f230907078301000067030c0010000044681a000001012878008a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001a0000000000000000000000000000000000000000000000000000000000000000d7";
        };
        config =
          let
            mode = "1920x1080";
          in
          {
            "eDP-1" = {
              inherit mode;
              position = "0x0";
            };
            "DVI-I-2-2" = {
              position = "${toString (1920 * 1)}x0";
              inherit mode;
              rotate = "right";
            };
            "DVI-I-1-1" = {
              position = "${toString (1920 * 2)}x0";
              inherit mode;
              primary = true;
            };
            "DP-2" = {
              position = "${toString (1920 * 3)}x0";
              inherit mode;
            };

          };
      };
    };
  };

  my.xsession.windowManager.i3.config = {
    startup =
      let
        images = lib.concatMapStringsSep " " (pape: "~/papes/${pape}") [
          "tavern.jpg"
          "rocknroll-futon-day.jpg"
          "girl-beach.jpg"
          "sky-library.jpg"
        ];
      in
      [
        {
          command = "${lib.getBin pkgs.feh} ${lib.cli.toGNUCommandLineShell {} {
          bg-center = true;
        }} ${images}";
          always = true;
          notification = false;
        }
      ];
    workspaceOutputAssign = [
      {
        output = "eDP-1";
        workspace = "10";
      }
      {
        output = "DVI-I-1-1";
        workspace = "1";
      }
      {
        output = "DVI-I-1-1";
        workspace = "2";
      }
      {
        output = "DVI-I-1-1";
        workspace = "3";
      }
      {
        output = "DVI-I-2-2";
        workspace = "4";
      }
      {
        output = "DVI-I-2-2";
        workspace = "5";
      }
      {
        output = "DVI-I-2-2";
        workspace = "6";
      }
      {
        output = "DP-2";
        workspace = "7";
      }
      {
        output = "DP-2";
        workspace = "8";
      }
      {
        output = "DP-2";
        workspace = "9";
      }
    ];
  };
}
