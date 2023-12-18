{config, ...}: let
  gfx = builtins.head config.services.xserver.videoDrivers;
  isNvidia = gfx == "nvidia";
  mkOutput = output:
    output
    + (
      if isNvidia
      then "0"
      else "1"
    );

  leftScreen = mkOutput "DVI-D-";
  frontScreen = mkOutput "DP-";
  rightScreen = mkOutput "HDMI-";
in {
  hardware.nvidia.forceFullCompositionPipeline = true;

  my.programs.autorandr = {
    enable = true;
    profiles."default" = {
      fingerprint = {
        ${leftScreen} = "00ffffffffffff0006b3a32501010101191e010380361e78ea4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0032901ea021000a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131323037380a01fc020104008a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077";
        ${frontScreen} = "00ffffffffffff0006b3a42501010101191e0104a5361e783b4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028a5c3c329010a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131313737320a01a8020318f14b900504030201111213141f2309070783010000a49c80a07038594030203500202f2100001a8a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000af";
        ${rightScreen} = "00ffffffffffff0006b3a325010101011a1e010380361e78ea4c801871382d40582c4500202f2100001e000000fd0028781e8c1e000a202c4d51533136373535320a012d020329f14b900504030201111213141f232c4030203500202f2100001afe5b80a07038354030203500202f210000100000000000000000000000000000000000000000d7";
      };
      config = {
        ${leftScreen} = {
          position = "0x0";
          rotate = "right";
          mode = "1920x1080";
        };
        ${frontScreen} = {
          position = "1920x0";
          mode = "1920x1080";
          primary = true;
        };
        ${rightScreen} = {
          position = "3840x0";
          mode = "1920x1080";
        };
      };
    };
  };

  my.xsession.windowManager.i3.config = {
    workspaceOutputAssign = [
      {
        output = leftScreen;
        workspace = "4";
      }
      {
        output = leftScreen;
        workspace = "5";
      }
      {
        output = leftScreen;
        workspace = "6";
      }

      {
        output = frontScreen;
        workspace = "1";
      }
      {
        output = frontScreen;
        workspace = "2";
      }
      {
        output = frontScreen;
        workspace = "3";
      }

      {
        output = rightScreen;
        workspace = "7";
      }
      {
        output = rightScreen;
        workspace = "8";
      }
      {
        output = rightScreen;
        workspace = "9";
      }
      {
        output = rightScreen;
        workspace = "10";
      }
    ];
  };
}
