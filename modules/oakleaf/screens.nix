{ config, ... }:

let
  gfx = builtins.head config.services.xserver.videoDrivers;
  isNvidia = gfx == "nvidia";
  mkOutput = output: 
    output + (if isNvidia then "0" else "1");

  leftScreen = "DP-2-1";
  rightScreen = "DP-2-2";
  computerScreen = "eDP-1";
  unknownHdmi = "HTMI-1";


in {

  hardware.nvidia.forceFullCompositionPipeline = true;
  
  my.programs.autorandr = {
    enable = true;
    profiles."reserve" = {
      fingerprint = {
        "DP-2-1" = "00ffffffffffff00220e623401010101261b0104a53420783a5595a9544c9e240d5054a10800b30095008100d1c0a9c081c0a9408180283c80a070b023403020360006442100001a000000fd00323c1e5011010a202020202020000000fc0048502045323433690a20202020000000ff0036434d373338323344520a20200016";
        "DP-2-8" = "00ffffffffffff00220eca3600000000131f0104a53420783ab265a9524f9d260d5054a10800d1c0a9c08100d100b3009500a9408180283c80a070b023403020360006442100001a000000fd00323c1e5011010a202020202020000000fc004850205a3234752047330a2020000000ff00434e343131393337484b0a202000be";
        "eDP-1" = "00ffffffffffff0026cf7f8500000000001d0104a51d11780ade50a3544c99260f505400000001010101010101010101010101010101383680a07038204018303c0026a510000019000000fe00523133334e564643205237200a00000003000326a2042c5c120808af00000000000003001951ff64a0f4120830c20101000011";
      };
      config = {
        "eDP-1" = {
          position = "0x0";
          mode = "1920x1080";
        };
        "DP-2-1" = {
          position = "1920x0";
          mode = "1920x1200";
        };
        "DP-2-8" = {
          position = "${toString (1920 * 2)}x0";
          mode = "1920x1200";
        };
      };
    };
      

    profiles."default" = {
      fingerprint = {
        ${leftScreen} = "00ffffffffffff0022f06e3200000000191b0104a5342078220285a556549d250e5054210800b30095008100d1c0a9c081c0a9408180283c80a070b023403020360006442100001a000000fd00323c1e5011010a202020202020000000fc00485020453234320a2020202020000000ff00434e34373235313633370a202000a8";
        ${rightScreen} = "00ffffffffffff0022f06e32000000001b1b0104a5342078220285a556549d250e5054210800b30095008100d1c0a9c081c0a9408180283c80a070b023403020360006442100001a000000fd00323c1e5011010a202020202020000000fc00485020453234320a2020202020000000ff00434e34373237303335360a202000a7";
        ${computerScreen} = "00ffffffffffff0026cf7f8500000000001d0104a51d11780ade50a3544c99260f505400000001010101010101010101010101010101383680a07038204018303c0026a510000019000000fe00523133334e564643205237200a00000003000326a2042c5c120808af00000000000003001951ff64a0f4120830c20101000011";
        ${unknownHdmi} = "00ffffffffffff0022f06f3201010101191b0103803420782a0285a556549d250e5054210800b30095008100d1c0a9c081c0a9408180283c80a070b023403020360006442100001a000000fd00323c1e5011000a202020202020000000fc00485020453234320a2020202020000000ff00434e34373235313633370a202001c1020318b148101f04130302121167030c0010000022e2002b023a801871382d40582c450006442100001e023a80d072382d40102c458006442100001e011d007251d01e206e28550006442100001e011d00bc52d01e20b828554006442100001e8c0ad08a20e02d10103e9600064421000018000000000000000000000000002f";
      };
      config = {
        ${leftScreen} = {
          position = "0x0";
          # rotate = "right";
          mode = "1920x1200";
        };
        ${rightScreen} = {
          position = "1920x0";
          mode = "1920x1200";
          primary = true;
        };
        ${computerScreen} = {
          position = "3840x0";
          mode = "1920x1080";
        };
      };
    };
  };

  my.xsession.windowManager.i3.config = {
    workspaceOutputAssign = [
      # { output = leftScreen; workspace = "1"; }
      # { output = leftScreen; workspace = "2"; }
      # { output = leftScreen; workspace = "3"; }
      # { output = leftScreen; workspace = "4"; }

      # { output = rightScreen; workspace = "5"; }
      # { output = rightScreen; workspace = "6"; }
      # { output = rightScreen; workspace = "7"; }
      # { output = rightScreen; workspace = "8"; }

      { output = computerScreen; workspace = "9"; }
      { output = computerScreen; workspace = "10"; }

      { output = "DP-2-1"; workspace = "5"; }
      { output = "DP-2-1"; workspace = "6"; }
      { output = "DP-2-1"; workspace = "7"; }
      { output = "DP-2-1"; workspace = "8"; }
      
      { output = "DP-2-8"; workspace = "1"; }
      { output = "DP-2-8"; workspace = "2"; }
      { output = "DP-2-8"; workspace = "3"; }
      { output = "DP-2-8"; workspace = "4"; }
    ];
  };
}

