{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.ejg = {
    # enable current shell to allow HM to inject stuff
    programs.bash.enable = true;
    home = {
      stateVersion = "21.11";
      keyboard = null;

      sessionVariables = {
        EDITOR = "nvim";
       	SUDO_EDITOR = "nvim";
      };
      shellAliases = {
        "c" = "cd /config";
        "..." = "cd ../..";
        "e" = "$EDITOR";
        "s" = "sudo";
        "se" = "sudoedit";
        "si" = "sudo -i";
        "nrs" = "sudo nixos-rebuild switch";
        "nrt" = "sudo nixos-rebuild test";
      };
      packages = with pkgs; [
        dmenu
        i3status
        i3lock
        xclip
      ];
    };                               

    xsession = {
      enable = true;
      initExtra = "autorandr -l mobile; autorandr -l docked";
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        config = rec {
          workspaceOutputAssign = [
            { workspace = "1"; output = "DVI-I-2-2"; }
            { workspace = "2"; output = "DVI-I-2-2"; }
            { workspace = "3"; output = "DVI-I-2-2"; }
            { workspace = "4"; output = "DVI-I-2-2"; }
            { workspace = "5"; output = "DVI-I-2-2"; }

            { workspace = "6"; output = "DVI-I-1-1"; }
            { workspace = "7"; output = "DVI-I-1-1"; }
            { workspace = "8"; output = "DVI-I-1-1"; }
            { workspace = "9"; output = "DVI-I-1-1"; }
            { workspace = "10"; output = "DVI-I-1-1"; }
          ]; 
          terminal = "kitty";
          modifier = "Mod4";
          keybindings = lib.mkOptionDefault {
              "${modifier}+q" = "split toggle";

              "${modifier}+Return" = "exec ${terminal}";
              "${modifier}+BackSpace" = "exec firefox";

              "${modifier}+h" = "focus left";
              "${modifier}+j" = "focus down";
              "${modifier}+k" = "focus up";
              "${modifier}+l" = "focus right";

              "${modifier}+Shift+h" = "move left";
              "${modifier}+Shift+j" = "move down";
              "${modifier}+Shift+k" = "move up";
              "${modifier}+Shift+l" = "move right";
            };
        };
      };
    };
    programs = {
      autorandr = {
        enable = true;
        hooks.predetect = {
          "add-displaylink-monitors" = "xrandr --setprovideroutputsource 1 0; xrandr --setprovideroutputsource 2 0";
        };
        profiles = {
          "mobile" = {
            fingerprint = {
              eDP1 = "00ffffffffffff0009e5c00600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe003138364743804e5631324e353100000000000041119e001000000a010a202000d6"; 
            };
            config = {
              eDP1 = {
                enable = true;
                position = "0x0";
                mode = "1920x1080";
                rate = "60.00";
              };
            };
          };
          "docked" = {
            fingerprint = {
              #laptop screen
              eDP1 = "00ffffffffffff0009e5c00600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe003138364743804e5631324e353100000000000041119e001000000a010a202000d6"; 
              #displaylink hdmi
              DVI-I-2-2 = "00ffffffffffff0006b3a325010101011a1e010380361e78ea4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028781e8c1e000a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533136373535320a012d020329f14b900504030201111213141f230907078301000067030c0010000044681a000001012878008a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001a0000000000000000000000000000000000000000000000000000000000000000d7";
              # displaylink displayport 
              DVI-I-1-1 = "00ffffffffffff0006b3a42501010101191e0104a5361e783b4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028a5c3c329010a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131323037380a01a8020318f14b900504030201111213141f2309070783010000a49c80a07038594030203500202f2100001a8a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000af";
            };
            config = {
              eDP1 = {
                enable = true;
                position = "3840x0";
                mode = "1920x1080";
                rate = "60.00";
              };
              DVI-I-2-2 = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "1920x1080";
                rate = "60.00";
              };
              DVI-I-1-1 = {
                enable = true;
                position = "1920x0";
                mode = "1920x1080";
                rate = "60.00";
              };
            };
          };
        };
      };
      neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [ vim-nix ];
	      extraConfig = ''
         set number
	       set tabstop=4 shiftwidth=4
         autocmd Filetype nix setlocal ts=2 sw=2
		    '';
      };
      kitty = {
        enable = true;
      };
      firefox = {
        enable = true;
        package = pkgs.firefox.override {
          cfg = {
            enableTridactylNative = true;
          };
        };
        profiles = {
          "main" = {
          };
        };
      };
      git = {
        enable = true;
        userEmail = "emanueljohnsongodin@gmail.com";
        userName = "emanueljg";
      };
    };
  };
}

