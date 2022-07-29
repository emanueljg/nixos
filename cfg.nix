{ config, pkgs, lib, modulesPath, system }:

rec {
  inherit (builtins)
    getAttr
    isList
    isString
    filter
    hasAttr
    concatStringsSep
    attrNames
    listToAttrs
    length
    replaceStrings
    attrValues
    all
  ;

  inherit (lib)
    lists
    foldl
  ;

  inherit (lib.attrsets) 
    mapAttrs 
    recursiveUpdate 
    genAttrs
    filterAttrs
    mapAttrsToList
    nameValuePair
    collect
    optionalAttrs
    cartesianProductOfSets
    getAttrFromPath
  ;

  inherit (lib.lists)
    flatten
    concatMap
    optionals
    optional
    range
    head
    findFirst
  ;

  inherit (lib.strings)
    concatStrings
    concatMapStrings
    removePrefix
    stringToCharacters
    removeSuffix
    intersperse
    hasInfix
    splitString
    hasPrefix
  ; 

  inherit (lib.trivial)
    const
  ;

  constants = {
    HOSTS = [
      "seneca"
      "aurelius"
    ];

    HM-VERSION = "22.05";

    GAP = 10;
    BAR-HEIGHT = 32;

    COLORS = {
      black = "#000000";
      white = "#FFFFFF";
      light-blue = "#7EBAE4";
      very-dark-blue = "#184094";
      dark-blue = "#5277C3";
      dark-purple = "#5C1A70";
      light-purple = "#BC79D1";
      purple = "#9036AC";
      pape-background = "#383535";  # warm grey
      dark-red = "#A83333";
      red = "#FF0A0A";
      green = "#1e942f";
      gold = "#bf9515";
      brown = "#ad5b1c";
      pink = "#fa0590";
      light-orange = "#F88379";
    };
  };
  
  funcs = rec {
    general = rec {
      getOrElse = key: default: set: 
        if (hasAttr key set) 
          then (getAttr key set)
          else default
      ;

      genDefault = keys: value:
        genAttrs 
          keys
          (k: value)
      ;

      # "sprid ut"
      doRecursiveUpdates = lhs: asas: 
        mapAttrs 
          (name: value: recursiveUpdate lhs value) 
          asas
      ;  

      # "plussa på"
      updateAttrs = ass: old: 
        foldl 
          (lhs: rhs: recursiveUpdate lhs rhs) 
          old 
          ass
      ;

      mkKnob = hosts: cfg:
        let
          hostList = 
            if (isList hosts) then hosts
            else if (isString hosts) then [ hosts ]
            else if (hosts) then constants.HOSTS
            else []
          ;
        in
          genAttrs 
            hostList 
            (host: ({ config, pkgs, lib, modulesPath, ...}: cfg ))
      ; 

      mkKnobs =
        let 
          eligibleKnobs = 
            filter
              (knob: (hasAttr system knob))
              knobs
          ;
        in
          map 
            (knob: getAttr system knob)
            eligibleKnobs
      ;
    };

    domain = { 
      i3 = rec {
        genColors = border-focused: indicator: border-unfocused:
          mapAttrs 
            (name: value: value // { childBorder = value.border; } )
            (general.doRecursiveUpdates
              { background = constants.COLORS.black; text = constants.COLORS.black; }
              rec {
                focused = { 
                  border = border-focused;
                  indicator = indicator;
                };

                unfocused = rec {
                  border = border-unfocused;
                  indicator = border;
                };

                focusedInactive = unfocused;
              }
            )
        ;

        genPolybarStartup =  
          concatMapStrings
            (bar: "polybar " + removePrefix "bar/" bar + " &") 
            (attrNames 
              (filterAttrs 
                (n: v: hasAttr "monitor" v) 
                config.home-manager.users.ejg.services.polybar.settings
              )
            )
        ;
      };
    };
  };

  # too often used to not make local
  inherit (funcs.general) 
    mkKnob
    mkKnobs
    readDesiredHost
  ;

  unstable = 
    import 
      (builtins.fetchTarball
        "https://github.com/nixos/nixpkgs/tarball/nixos-unstable"
        )
      { config = config.nixpkgs.config; }    
  ;

  knobs = [
    # IMPORTANT - generates the host etc files
    (mkKnob [ "aurelius" "seneca" ]
      (let
        home-manager = 
          builtins.fetchTarball 
            "https://github.com/nix-community/home-manager/archive/release-${constants.HM-VERSION}.tar.gz"
          ;
        in {
          imports = [
            (import "${home-manager}/nixos")
            (lib.mkAliasOptionModule ["my"] ["home-manager" "users" "ejg"])
          ];

          my.home.stateVersion = constants.HM-VERSION;
        }
      )
    )

    # meta
    (mkKnob [ "aurelius" "seneca" ] {
      system.stateVersion = "22.05";
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        xterm
        wget
        acpi
        htop
        xclip
        scrot
        nixos-option
        zip
        unzip
      ];
    })

    # hwconfig-seneca
    (mkKnob [ "seneca" ] {
      imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

      boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/6b3abb60-4f69-4779-83ff-8765e3bdbab6";
          fsType = "ext4";
        };

      fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/3966-8D70";
          fsType = "vfat";
        };

      swapDevices =
        [ { device = "/dev/disk/by-uuid/b24f8679-5735-45d0-8d28-356a0692c23c"; }
        ];

      powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    })

    # hwconfig-aurelius
    (mkKnob [ "aurelius" ] {
      imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

      boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      boot.kernelParams = [ "systemd.unified_cgroup_hierarchy=0" ]; 

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/89f97719-9a2f-43ee-9279-42542470fa19";
          fsType = "ext4";
        };

        "/boot" = {
          device = "/dev/disk/by-uuid/BE53-94B3";
          fsType = "vfat";
        };

        "/mnt/data" = {
          device = "/dev/disk/by-uuid/7B171917468EA7D0";
          fsType = "ntfs";
        };
      };
      swapDevices =
        [ { device = "/dev/disk/by-uuid/92a741d1-7a27-4ba6-b7d2-9476378ff865"; } ];

      powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    })
    
    # boot-base
    (mkKnob [ "aurelius" "seneca" ] {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    })

    # boot-silent
    # want to keep it off for now, easier that way
    (mkKnob [ ] {
      boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        loader.timeout = 0;
        kernelParams = [
          "quiet"
          "splash"
          "bgrt_disable"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
          "boot.shell_on_fail"
        ];
        plymouth = {
          enable = true;
          theme = "breeze";
        };
      };
    })

    # boot-hibernation
    (mkKnob [ "aurelius" "seneca"] {
      my.home.packages = [ pkgs.pmutils ];
      boot.resumeDevice = "/dev/sda2";
      # used to be needed for dock
      # powerManagement.resumeCommands = ''
      #   ${config.my.xsession.windowManager.i3.package}/bin/i3-msg restart
      # '';
      my.home.shellAliases."hib" = "sudo pm-hibernate";
    })
  
    # locale-base
    (mkKnob [ "aurelius" "seneca" ] {
      i18n = ( 
        let
          en = "en_US.UTF-8";
          sv = "sv_SE.UTF-8";
        in {
          defaultLocale = en;
          extraLocaleSettings = (
            genAttrs
              [ 
                "LC_TIME"
                "LC_MONETARY"
                "LC_PAPER"
                "LC_NAME"
                "LC_TELEPHONE"
              ]
              (const sv)
          );
        }
      );

      time.timeZone = "Europe/Stockholm";
      console.keyMap = "sv-latin1";
    })

    # user-base
    (mkKnob [ "aurelius" "seneca" ] {
      users.users.ejg = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      security.sudo.wheelNeedsPassword = false;
    })

    # network-base
    (mkKnob [ "aurelius" "seneca" ] { 
      networking = {
        useDHCP = false;
        wireless.enable = false;
        networkmanager.enable = true;
      };
    })
    
    # network-seneca
    (mkKnob [ "seneca" ] {
      networking = {
        hostName = "seneca";
        interfaces = {
          enp0s20f0u3u1i5.useDHCP = false;
          enp0s31f6.useDHCP = false;
          wlan0.useDHCP = true;
        };
      };
    })

    # network-aurelius
    (mkKnob [ "aurelius" ] {
      networking = {
        hostName = "aurelius";
        firewall.enable = false;
        interfaces = {
          wlp2s0.useDHCP = true;
          eno1.useDHCP = false;
        };
      };
    })

    # server-ssh 
    (mkKnob [ "aurelius" ] {
      services.openssh = {
        enable = true;
        ports = [ 34022 ];
        authorizedKeysFiles = [ "/home/ejg/.ssh/id_ed25519.pub" ];
      };
    })

    # server-deluge
    (mkKnob [ "aurelius" ] {
      services.deluge = {
        enable = true;
        declarative = true;
        openFirewall = true;

        config = {
          allow_remote = true;
          daemon_port = 58846;

          download_location = "/mnt/data/torrs/";

          # disable this for now, more hassle than it's worth
          #move_completed = true;
          #move_completed_path = "/mnt/data/torrs";

          max_upload_speed = 0;
          max_download_speed = 1000;
          max_active_downloading = 3;
          listen_ports = [6881 6891];
        };

        web = {
          enable = true;
          port = 34012;
          openFirewall = true;
        };
      };

      # creates the auth file
      systemd.tmpfiles.rules = [ 
        (''f+ /tmp/deluge/deluge-auth 0550 deluge deluge - localclient:password:10\nejg:password:10'')
      ];

      # sets the auth file
      services.deluge.authFile = "/tmp/deluge/deluge-auth";
    })

    # server-jellyfin
    (mkKnob [ "aurelius" ] {
      hardware.opengl.driSupport32Bit = true;
      services.xserver.videoDrivers =  [ "nvidia" ];
      hardware.opengl.enable = true;

      virtualisation = {
        docker.enableNvidia = true;
        oci-containers = {
          backend = "docker";
          containers."jellyfin" = {
            autoStart = true;
            image = "jellyfin/jellyfin";
            volumes = [
              "/var/cache/jellyfin/config:/config"
              "/var/cache/jellyfin/cache:/cache"
              "/var/log/jellyfin:/log"
              "/mnt/data:/media:ro"
            ];
            ports = [ "8096:8096" ];
            extraOptions = [ "--runtime=nvidia" ];
            environment = {
              JELLYFIN_LOG_DIR = "/log";
              NVIDIA_DRIVER_CAPABILITIES = "all";
              NVIDIA_VISIBLE_DEVICES = "all";
            };
          };
        };
      };
    })
  
    # server-invidious
    (mkKnob [ "aurelius" ] {
      services.invidious.enable = true;
      
      # setup ports
      services.invidious = {
        port = 34030;
        database.port = 34031;
      };

      networking.firewall.allowedTCPPorts = [ 
        config.services.invidious.port
        config.services.invidious.database.port
      ];
    })
  
    # server-ytd-basedef
    (mkKnob [ "aurelius" ] (let cfg = config.ytd; in with lib; {
      options.ytd = {
        enable =  mkEnableOption "Enables ytd.";

        defaultFlags = mkOption {
          type = types.attrs;
        }; 
        
        download = mkOption {
          default = [ ];
        };
      };
    
      config = 
        let

          inherit (funcs.general) getOrElse;

          interpretFlags = flags:
            mapAttrsToList
              (name: value: 
                let
                  prefixedArg =
                    (if ((stringLength name) == 1)
                      then "-"
                      else "--"
                      )
                    + 
                    name
                  ;
                in
                  if 
                    (isString value) then 
                      "${prefixedArg} ${value}"
                    else if ((isBool value) && (value)) then
                      "${prefixedArg}"
                    else
                      ""
                )
              flags
          ;
        
          completeFlags = video:
            interpretFlags
              (cfg.defaultFlags // (getOrElse "flags" {} video))
          ;
          
          mkCmd = video:
            concatStringsSep
              " "
              (
                # base command
                [ "${pkgs.yt-dlp}/bin/yt-dlp" ]
                  
                  # flags
                  ++ (completeFlags video)
                      
                  # url
                  ++ [ video.url ]
                )
          ;
        
          mkCmdsChain = 
            concatStringsSep
              " && "
              (map
                mkCmd
                cfg.download
                )    
          ;
          
        in mkIf cfg.enable {
          # add package first
          environment.systemPackages = [ pkgs.yt-dlp ];
          
          systemd.services."ytd" = rec {
            after = [ "network-online.target" ];
            before = [ "multi-user.target" ];
            wantedBy = before;
            serviceConfig = {
              ExecStart = mkCmdsChain;
              type = "forking";
            };
          };    
        }
      ;
    }))
  
    # server-ytd-impl
    (mkKnob [ "aurelius" ] {
      ytd = 
        let
          baseDir = "/mnt/data/vids/yt";
          mkVidDir = dir: baseDir + dir;
        in {
          enable = true;

          defaultFlags = {
            limit-rate = "500K";
            write-thumbnail = true;
            write-info-json = true;
            #output = "%(title)s.%(ext)s";
          };
                
          download = [
            { 
              url = "https://www.youtube.com/playlist?list=PLrQI1-ZsRXgVRJVRAQocmcNK7PHz8kpbn";
              flags = {
                paths = mkVidDir "/kripp/twinshine";
              };
            }
            
            { 
              url = "https://www.youtube.com/playlist?list=PLrQI1-ZsRXgV2RLR7eYLup8yms65MYldK";
              flags = {
                paths = mkVidDir "/kripp/chronicles";
              };
            }
          ];
        }
      ;
    })

    # sound
    (mkKnob [ "aurelius" "seneca" ] {
      sound.enable = true;
      hardware.pulseaudio.enable = true;
    })

    # shell-base
    (mkKnob [ "aurelius" "seneca" ] {
      my = {
        # enable current shell to allow HM to inject stuff
        programs.zsh.enable = true;
        home = {
          sessionVariables = rec {
            VISUAL = "hx";
            EDITOR = VISUAL;
            SUDO_EDITOR = VISUAL;
          };

          shellAliases = {
            "c" = "cd /config";
            "..." = "cd ../..";

            "e" = "$EDITOR";

            "s" = "sudo";
            "se" = "sudoedit";
            "si" = "s -i";

            "nrs" = "sudo nixos-rebuild switch";
            "nrt" = "sudo nixos-rebuild test";
            "lnk" = ''basename "$(readlink /etc/nixos/configuration.nix)" | sed 's/\(.*\).nix/\1/g' '';

            "xc" = "xclip -sel clip";
            "xp" = "xc -o";

            "g" = "git";

            "gs" = "g status";

            "gb" = "g branch";
            "gbd" = "gb -d";

            "gch" = "g checkout";
            "gchb" = "g checkout -b";

            "gm" = "g merge"; 

            "ga" = "g add";

            "gco" = "g commit -m";
            "gcoa" = "g commit -am";

            "gpush" = "g push";
            "gpull" = "g pull";

            "gl" = "g log";
            "gd" = "g diff";

            "skk" = "kitty +kitten ssh";
            "aur" = "skk ejg@192.168.1.2 -p 34022";

            "aurt" = "deluge-console -d 192.168.1.2 -p 58846 -U ejg -P password";
            "aurti" = "aurt info";
            "aurta" = "aurt add";
            "aurtax" = "aurta $(xp)"; 
          
            "pling" = ''while :; do sleep 0.75 && echo -e "\a"; done''; 
          } 
          ;
        };
      };
    })

    # x-base
    (mkKnob [ "aurelius" "seneca" ] {
      services.xserver = {
        enable = true;
        libinput.enable = true;

        # this should fix the constant display powersaving
        # (that doesn't even work properly with the dock)
        # config = lib.mkAfter ''
        #   Section "Extensions"
        #     Option "DPMS" "Disable"
        #   EndSection
        # '';
      };

      my = {
        home.keyboard = null;
        fonts.fontconfig.enable = lib.mkOverride 0 true;
      };

      services.xserver.layout = "se";
    })

    # x-hm-fast
    # 
    # we let core nix "handle" a dummy session
    # while the real session is started by HM.
    # can't remember why this is needed, but it
    # has something  to do with i3 being a (T)WM
    # and fast x login 
    (mkKnob [ "aurelius" "seneca" ] {
      services.xserver.displayManager = {
        autoLogin = {
          enable = true;
          user = "ejg";
        };
        session = let fakeSession = {
          manage = "window";
          name = "fake";
          start = "";
        }; in [ fakeSession ];
        defaultSession = "none+fake";
        lightdm.greeter.enable = false; 
      };

      my.xsession.enable = true;
    })
  
    # display-power
    (mkKnob [ "seneca" ] {
      services.logind.lidSwitch = "ignore";
      
      systemd.targets = {
        sleep.enable = false;
          suspend.enable = false;
          hybrid-sleep.enable = false;
      };
    })

    # display-opengl
    (mkKnob [ "aurelius" "seneca" ] {
      hardware.opengl.enable = true;
    })


    # pkgs-i3
    (mkKnob [ "aurelius" "seneca" ] {
      my.xsession.windowManager.i3 = with funcs.domain.i3; {
        enable = true;
        package = pkgs.i3-gaps;
          config = rec {
            startup = [
              {
                command = "feh --bg-fill ~/pape";
                always = true;
                notification = false;
              }
              {
                command = genPolybarStartup; 
                always = true;
                notification = false;
              }
            ];
        
            defaultWorkspace = "workspace number 1";
            
            gaps = { 
              "bottom" = constants.GAP + constants.BAR-HEIGHT + constants.GAP; 
              "inner" = constants.GAP + constants.GAP; 
            };

            window.border = constants.GAP / 2;

            colors =  
              genColors 
                constants.COLORS.dark-blue 
                constants.COLORS.light-blue 
                constants.COLORS.black;

            bars = [ ];
            terminal = "kitty";
            modifier = "Mod4";
            keybindings = lib.mkOptionDefault {
                "${modifier}+q" = "split toggle";

                "${modifier}+Return" = "exec ${terminal}";
                "${modifier}+BackSpace" = "exec qutebrowser";

                "${modifier}+h" = "focus left";
                "${modifier}+j" = "focus down";
                "${modifier}+k" = "focus up";
                "${modifier}+l" = "focus right";

                "${modifier}+Shift+h" = "move left";
                "${modifier}+Shift+j" = "move down";
                "${modifier}+Shift+k" = "move up";
                "${modifier}+Shift+l" = "move right";

                "${modifier}+Up" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
                "${modifier}+Down" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            };
          };
        };
    })

    # pkgs-polybar
    (mkKnob [ "aurelius" "seneca" ] {
      my.services.polybar = {
        enable = true;
        package = pkgs.polybar.override {
          i3GapsSupport = true;
          githubSupport = true;
          pulseSupport = true;
        };
        script = "";
        settings = (
          funcs.general.doRecursiveUpdates
            {
              format = {
                background = constants.COLORS.dark-blue;
                padding = 1;
              };
            }
            {
              "module/i3" = 
                let
                  labels = genAttrs 
                    [ "label-focused" "label-unfocused" "label-visible" ] 
                    (name: { text = "%name%"; padding = 1; background = constants.COLORS.dark-blue; });
                in 
                  recursiveUpdate labels {
                    format.padding = 0;
                    type = "internal/i3";
                    pin-workspaces = true;
                    show-urgent = true;
                    strip-wsnumbers = true;
                    index-sort = true;
                    enable-click = false;
                    enable-scroll = false;
                    wrapping-scroll = false;
                    reverse-scroll = false;
                    label-focused.background = constants.COLORS.light-blue;
              };
              "module/time" = {
                type = "internal/date";
                internal = 5;
                time = "%H:%M";
                label = "%time%";
              };
              "module/date" = {
                type = "internal/date";
                internal = 5;
                date = "%Y-%m-%d | %a"; 
                label = "%date%";
              };
              "module/xwindow" = {
                type = "internal/xwindow";
              };
              "module/battery" = {
                type = "internal/battery";
                battery = "BAT0";
                adapter = "AC";
                ramp-capacity = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
                format = {
                  discharging.text = "<ramp-capacity>󱐥 <label-discharging>";
                  charging.text = "<ramp-capacity>󰚥 <label-charging>";
                  full.text = "<ramp-capacity>󰸞 <label-full>";
                };
                label.text = "%percentage%%";
                low-at = 10; 
              };

              "module/pulseaudio" = {
                type = "internal/pulseaudio";
                format-volume = "<ramp-volume> <label-volume>";
                ramp-volume = [ "󰕿" "󰖀" "󰕾" ];
                label-muted = "󰖁";
              };

              "module/network" = (
                let
                  guessWirelessIface = (
                    findFirst
                      (hasPrefix "w")
                      null
                      (attrNames config.networking.interfaces)
                  );
                in {
                  type = "internal/network";
                  interface = guessWirelessIface;
                  ramp-signal = [ "󰣾" "󰣴" "󰣶" "󰣸" "󰣺" ];
                  format = {
                    connected.text = "<ramp-signal>";
                    disconnected.text = "󰣽";
                    packetloss.text = "󰣻";
                  };
                }
              );
            }
          );
        };
    })
  
    (mkKnob [ "aurelius" "seneca" ] (let cfg = config.custom; in with lib; {
      options.custom = {
        monitors = mkOption {
          description = "all monitors";
          type = with types; attrsOf (submodule {
            options = {
              autorandr = mkOption {
                type = attrs;
              };
              
              workspaces = mkOption {
                type = listOf int;
              };

              bars = mkOption {
                type = attrs;
              };            
            };
          });
        };
      };

      config = ( 
        let
          getBar = monitor: adjustStr: 
            config.my.services.polybar.settings."bar/${monitor}-${elemAt (splitString " " adjustStr) 1}"
          ;
          resolveBars = (
            mapAttrs
              (monName: monValue: 
                recursiveUpdate 
                  (removeAttrs monValue [ "autorandr" "workspaces" ]) 
                  {
                    bars = (  
                      mapAttrs'
                        (barName: barValue: 
                          nameValuePair
                            ("bar/${monName}-${barName}")
                            (pipe barValue [
                              # set monitor
                              (bar: bar // { "monitor" = "\${env:MONITOR:${monName}}"; })
                              # add in modules-center if not found
                              (bar: bar // (
                                      optionalAttrs
                                        (! (any (hasPrefix "modules") (attrNames bar)))
                                        { "modules-center" = "${barName}"; }
                                    )
                              )
                              # set workspace bar width
                              (bar: bar // (
                                      optionalAttrs 
                                        (barName == "workspaces")
                                        { width = (
                                            let 
                                              workspaceList = cfg.monitors.${monName}.workspaces;
                                              chars = 
                                                foldl
                                                  (a: b: a + b)
                                                  0
                                                  (map 
                                                    (workspaceNum: 
                                                      length (stringToCharacters (toString (workspaceNum)))
                                                      )
                                                    workspaceList
                                                    )
                                              ;
                                            in
                                              (chars + (length workspaceList) * 2) * 12
                                          ); 
                                        }
                                    )
                              )
                              # set width for workspace bar
                              (bar: if (bar."_adjust" == "left")
                                    then (bar // { "offset-x" = 20; })
                                    
                                    else if (bar."_adjust" == "right") 
                                    then (bar // { "offset-x" = (1920 - 20 - bar."width"); })

                                    else if (hasPrefix "leftOf" bar."_adjust") 
                                    then (bar // { "offset-x" = (let abs = (getBar monName bar."_adjust"); in abs.offset-x - 20 - bar.width); })

                                    else if (hasPrefix "rightOf" bar."_adjust") 
                                    then (bar // { "offset-x" = (let abs = (getBar monName bar."_adjust"); in abs.offset-x + abs.width + 20); })
  
                                    else bar
                              )
                              (bar: removeAttrs bar [ "_adjust" ])                     
                            ])
                        )
                        monValue.bars
                
                    );
                  }
              )
              cfg.monitors 
          );
        in {       
          my.services.polybar.settings = (
            funcs.general.doRecursiveUpdates 
              ({
                bottom = true;
                background = constants.COLORS.dark-blue;
                foreground = constants.COLORS.white;
                override-redirect = true;
                wm-restack = "i3";
                height = constants.BAR-HEIGHT;
                offset.y = 20;
                # radius = 0;
                font = [ 
                  "JetBrains Mono:pixelsize=16:weight=bold;3" 
                  "Material Design Icons:size=18:style=Regular;3"
                ];
                locale = config.i18n.extraLocaleSettings.LC_TIME;
              })
            
              (
                funcs.general.updateAttrs 
                  (
                    collect 
                      (s: any (hasAttr "width") (attrValues s))
                      (resolveBars)
                  )
                  {}
              )
          );

          my.xsession.windowManager.i3.config.workspaceOutputAssign = (
            flatten
              (mapAttrsToList 
                (output: workspaces: 
                  (map 
                    (workspace: { "output" = output; "workspace" = toString workspace; }) 
                    workspaces
                  )
                )
                (
                  mapAttrs
                    (n: v: v.workspaces)
                    cfg.monitors
                )
              )
          );
        }
      );
    }))

    (mkKnob [ "aurelius" "seneca" ] {
      custom.monitors = 
        let
          default = {
            autorandr = {
              enable = true;
              inProfile = "default";
              mode = "1920x1080";
              rate = "60.00";
              # fingerprint = ???
              # primary = ???
            };
      
            # old battery width = 135
            bars = {
              workspaces = { modules-left="i3"; width = "x"; _adjust = "left"; };

              time =       {                    width = 84;  _adjust = "right"; };
              date =       {                    width = 216; _adjust = "leftOf time"; };
              battery =    {                    width = 0;   _adjust = "leftOf date"; };
              pulseaudio = {                    width = 110; _adjust = "leftOf date"; };
              network =    {                    width = 40;  _adjust = "leftOf pulseaudio"; };
            };
          };

        in funcs.general.doRecursiveUpdates default {        
          "DP-0" = {
            autorandr = {
              fingerprint = "00ffffffffffff0006b3a425010101011a1e0104a5361e783b4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0028a5c3c329010a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533136373535320a01a0020318f14b900504030201111213141f2309070783010000a49c80a07038594030203500202f2100001a8a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000af"; 
              primary = true;
              position = "0x0";
            };
    
            workspaces = range 1 5;
          };

          "DVI-D-0" = {
            autorandr = {
              fingerprint = "00ffffffffffff0006b3a32501010101191e010380361e78ea4c00a75552a028135054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500202f2100001e000000fd0032901ea021000a202020202020000000fc0056473235380a20202020202020000000ff004c364c4d51533131323037380a01fc020104008a4d80a070382c4030203500202f2100001afe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001afc7e80887038124018203500202f2100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077";
              position = "1920x0";
            };
            
            workspaces = range 6 10;
          };
        };
    })
  
    # pkgs-zsh
    (mkKnob [ "aurelius" "seneca" ] {
      # sets default shell
      users.users.ejg.shell = pkgs.zsh;

      # required for
      # https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.enableCompletion
      environment.pathsToLink = [ "/share/zsh" ];

      my.programs.zsh = {
        enable = true;
        enableSyntaxHighlighting = true;
        enableVteIntegration = true;
        autocd = true;
        # cdpath = [ ]  could try and add this later?
        # defaultKeymap  perhaps this too
        # dirHashes     definitely this, could be very useful
      
        localVariables = {
          PROMPT="%F{68}%n@%m%f:%F{14}%~%f $ ";
        };
      };
    })
  
    # pkgs-pfetch
    (mkKnob [ "aurelius" "seneca" ] {
      my.home = {
        packages = [ pkgs.pfetch ]; 
        shellAliases."pf" = "echo && pfetch"; # inserts a newline before pfetch 
        sessionVariables = {
          PF_INFO = "ascii os host kernel wm editor pkgs memory";
          PF_COL1 = 6;
          PF_COL2 = 4; 
          PF_COL3 = 4;
        };
      };
    })

    # pkgs-kitty 
    (mkKnob [ "aurelius" "seneca" ] {
      my.programs.kitty = {
        enable = true;
        font = {
          name = "JetBrains Mono";
        };

        settings = { 
          confirm_os_window_close = 0; 
          window_padding_width = 4;
        };

        # manually load the Clrs theme
        extraConfig = ''
          # vim:ft=kitty
          ## name: Doom One Light
          ## author: Henrik Lissner <https://github.com/hlissner>
          ## license: MIT
          ## blurb: Doom Emacs flagship theme based on atom One Light
          # The basic colors
          foreground                      #383a42
          background                      #fafafa
          selection_foreground            #383a42
          selection_background            #dfdfdf
          # Cursor colors
          cursor                          #383a42
          cursor_text_color               #fafafa
          # kitty window border colors
          active_border_color     #0184bc
          inactive_border_color   #c6c7c7
          # Tab bar colors
          active_tab_foreground   #fafafa
          active_tab_background   #383a42
          inactive_tab_foreground #f0f0f0
          inactive_tab_background #c6c7c7
          # The basic 16 colors
          # black
          color0 #383a42
          color8 #c6c7c7
          # red
          color1 #e45649
          color9 #e45649
          # green
          color2  #50a14f
          color10 #50a14f
          # yellow
          color3  #986801
          color11 #986801
          # blue
          color4  #4078f2
          color12 #4078f2
          # magenta
          color5  #a626a4
          color13 #b751b6
          # cyan
          color6  #005478
          color14 #0184bc
          # white
          color7  #f0f0f0
          color15 #383a42
        '';
    #    settings = {
    #      background = COLORS.dark-blue;
    #      foreground = COLORS.white;
    #    };
        
      };
    })

    # qutebrowser-extra
    # Sets some extra hardcoded python stuff by overlaying the postInstall and sedding away
    (mkKnob [ "aurelius" "seneca" ] {
      my.nixpkgs.overlays = 
        let
          # custom variables
          activeDownloadFormat = "({index}) {name} | {total} | {perc:<2}% | {speed:<10}";
          doneDownloadFormat = "({index}) {name} | {total} | {perc:<2}% | Finished!"; 

          # inferred
          setActiveDownloadsFormat = concatStrings [
            # This format is defined over two lines in the original python class, 
            # requiring two sed commands to fully change it.

            ''cat ''
              ''"qutebrowser/browser/downloads.py"''
            
            " | "

            ''sed "s''
                ''/{index}: {name} \[{speed:>10}|{remaining:>5}|{perc:>2}%|''
                ''/${activeDownloadFormat}''
            ''/g"''
            
            " | "

            ''sed "s''
                ''/{down}\/{total}\]''
                ''/''  # delete
            ''/g"''

            # Set done downloads format
            # sed "s/{index}: {name} \[{perc:>2}%|{total}\]/FOUND2/g"

            " | "

            ''sed "s''
              ''/{index}: {name} \[{perc:>2}%|{total}\]''
              ''/${doneDownloadFormat}''
            ''/g"''
              
            " > "
              
            ''"$out/lib/python3.9/site-packages/qutebrowser/browser/downloads.py"''
          ];



        in
          [(self: super: {
              qutebrowser = super.qutebrowser.overrideAttrs (oldAttrs: rec {
                postInstall = oldAttrs.postInstall + ''
                  ${setActiveDownloadsFormat}
                '';
              });
            }
          )]
      ;
    })

    # pkgs-qutebrowser
    (mkKnob [ "aurelius" "seneca" ] {
      my.programs.qutebrowser = {
        enable = true;
        searchEngines = {
          DEFAULT = "https://www.google.com/search?q={}";
          yt = "http://192.168.1.2:34030/search?q={}";
        };
        keyBindings = {
          normal = {
            "J" = "tab-prev";
            "K" = "tab-next";
            "gJ" = "tab-move -";
            "gK" = "tab-move +";
            "ew" = "jseval -q document.activeElement.blur()";
            "eb" = "spawn --userscript /config/parts/home/programs/qutebrowser/edit-quickmarks.sh";  # doesn't work as of yet
            ",d" = ''hint links spawn zsh -lic "aurta {hint-url}"''; 
            ",yy" = ''yank inline https://youtube.com/watch?{url:query}'';
          };
        };
        settings = with constants.COLORS; {
          colors = {
            statusbar = {
              normal = {
                fg = white;
                bg = dark-blue;
              };
              insert = {
                fg = white;
                bg = light-blue;
              };
            };
          };
        };
      };
    })
  
    # pkgs-qutebrowser-translate
    (mkKnob [ "aurelius" "seneca" ] {
      my = with pkgs; ( 
        let
          qute-translate = (
            callPackage
              ({lib, pkgs}: stdenv.mkDerivation rec {
                name = "qute-translate";
    
                src = pkgs.fetchFromGitHub {
                  owner = "AckslD";
                  repo = "Qute-Translate";
                  rev = "cd2d201d17bb2d7490700b20d94495327af15e78";
                  sha256 = "sha256-xCbeEAw8a/5/ZD9+aB1J7FxLLBlP65kslGtpYGn3efs=";
                };
            
                installPhase = "install -Dm555 translate $out/translate";
              })
            {}
          );
        in {
          home.packages = [ qute-translate ];
          programs.qutebrowser.keyBindings.normal.",t" = (
            "spawn --userscript ${qute-translate}/translate"
          );
        }
      );
    })
  
    # pkgs-qutebrowser-qms
    (mkKnob [ "aurelius" "seneca" ] {
      my.programs.qutebrowser.quickmarks = {
        # f (feed)
        f-m = "https://mail.google.com/mail/u/0/#inbox";
        f-d = "https://discord.com/channels/@me";
        f-ch = "https://https://4chan.org/";

        # t (tech)
          t-1 = "https://github.com/emanueljg/nixos";

          # t-no (tech-nixos)
          t-no-opt = "https://search.nixos.org/options";
          t-no-hm = "https://nix-community.github.io/home-manager/options.html";
          t-no-pkgs = "https://search.nixos.org/packages";
          t-no-lang = "https://teu5us.github.io/nix-lib.html#nix-builtin-functions";

          # t-qb (tech-qutebrowser)
          t-qb-faq = "https://qutebrowser.org/FAQ.html";
          t-qb-func = "https://qutebrowser.org/doc/help/commands.html";
          t-qb-us = "https://qutebrowser.org/doc/userscripts.html";

          # t-dl (tech-downloads)
          t-dl-nsi = "https://nyaa.si/";
          t-dl-rbg  = "https://rarbg.to/torrents.php";
          t-dl-1337x = "https://www.1377x.to/";

        # s (server)
        s-dl = "192.168.1.2:34012";
        s-jf = "192.168.1.2:8096";
      
        # m (my)
          
          # m-j (my-japanese)
          m-j-k = "https://itazuraneko.neocities.org/learn/kana.html";
      };
    })

    # pkgs-git
    (mkKnob [ "aurelius" "seneca" ] {
      my.programs = {
        git = {
          enable = true;
          userEmail = "emanueljohnsongodin@gmail.com";
          userName = "emanueljg";
        };
        
        gh.enable = true;
      };
    })

    # pkgs-neovim
    (mkKnob [ "aurelius" "seneca" ] {
      my.programs.neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [ 
          vim-nix 
        ];
        extraConfig = ''
         set number
         set tabstop=4 shiftwidth=4
         autocmd Filetype nix setlocal ts=2 sw=2
         :command Nrs !sudo nixos-rebuild switch
        '';
      };
    })

    # try out helix on trial
    (mkKnob [ "aurelius" "seneca" ] {
      my.programs.helix = {
        enable = true;
        package = unstable.helix;
        settings = {
          theme = "snowy";
          editor = {
            line-number = "relative";
            auto-pairs = false;  # simple fix, having it on is more trouble than it's worth for now
          };
        };

        themes = {
          snowy = with constants;
            let
              transparent = "none";
              gray = "#665c54";
              dark-gray = "#3c3836";
              white = "#fbf1c7";
              black = "#282828";
              red = "#fb4934";
              green = "#b8bb26";
              yellow = "#fabd2f";
              blue = "#83a598";
              magenta = "#d3869b";
              cyan = "#8ec07c";
            in rec {
              # menu
                # bottom 
                  # status bar 
                    "ui.statusline" = { fg = COLORS.white; bg = COLORS.dark-blue; };
                    "ui.statusline.inactive" = { fg = COLORS.dark-blue; bg = white; };

                  # command autocomplete popup
                    "ui.menu" = { fg = COLORS.white; bg = COLORS.dark-blue; };
                    "ui.menu.selected" = { fg = COLORS.white; bg = COLORS.light-blue; };
                    "ui.help" = { fg = COLORS.white; bg = COLORS.light-blue; };
                
                # left side (gutters)
                  # diagnostics (left of line numbers)
                    "diagnostics" = { fg = COLORS.white; bg = COLORS.dark-blue; };
              
                  # line numbers
                    "ui.linenr" = { fg = COLORS.white; bg = COLORS.dark-blue; };
                    "ui.linenr.selected" = { fg = COLORS.white; bg = COLORS.light-blue; modifiers = [ "bold" ]; };

                # right side (only "extra commands"-popup for now)              
                  "ui.popup" = COLORS.dark-blue;

              # otherwise meta
                "ui.selection" = { modifiers = [ "underlined" ]; };
                "ui.selection.primary" = {  modifiers = [ "underlined" ]; };
                "ui.cursor" = { modifiers = [ "reversed" ]; };
                "ui.cursor.match" = { modifiers = [ "reversed" "bold" ]; };
              
              # syntax
                "comment" = { fg = gray; };
                "variable" = COLORS.dark-blue;
                "constant" = COLORS.gold;
                "attributes" = yellow;
                "type" = "#fa0590";
                "string" = COLORS.green;
                "variable.other.member" = COLORS.very-dark-blue;
                "function" = COLORS.pink;
                "keyword" = COLORS.purple;

              # (unknowns/unused)
                "ui.window" = COLORS.pink;
                "variable.builtin" = COLORS.pink;
                "constant.numeric" = COLORS.pink;
                "constant.character.escape" = COLORS.pink;
                "constructor" = COLORS.pink;
                "special" = COLORS.pink;
                "label" = COLORS.pink;
                "namespace" = COLORS.pink;
                "diff.plus" = COLORS.pink;
                "diff.delta" = COLORS.pink;
                "diff.minus" = COLORS.pink;
                "diagnostic" = COLORS.pink;
                "info" = COLORS.pink;
                "hint" = COLORS.pink;
                "debug" = COLORS.pink;
                "warning" = COLORS.pink;
                "error" = COLORS.pink;
            }
          ;
        };
      };
    })
    
    # pkgs-helix-patch-aurelius-default-editor
    (mkKnob [ "aurelius" ] {
      environment.sessionVariables."EDITOR" = "hx";
    })

    # misc-dircolors
    (mkKnob [ "aurelius" "seneca" ] {
      my.programs.dircolors = {
        enable = true;
        settings = {
          OTHER_WRITABLE = "01;33";
        };
      };
    })

    # misc seneca packages
    (mkKnob [ "aurelius" "seneca" ] {
      my.home.packages = with pkgs; [
        dmenu
        i3status
        i3lock
        xclip
        vegur
        material-design-icons
        feh
        mpv
        pv
        jetbrains-mono
        appimage-run
      ];
    })

    # seneca flatpaks
    (mkKnob [ "seneca" ] {
      services.flatpak.enable = true;
      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    })

    # pkgs-appimage-artix-games-launcher
    (mkKnob [ "seneca" ] {
      environment.systemPackages = [
        (pkgs.callPackage 
          ({appimageTools, lib, pkgs }: appimageTools.wrapType2 rec {
            pname = "artix-games-launcher";
            version = "latest";
        
            src = builtins.fetchurl {
              url = "https://launch.artix.com/latest/Artix_Games_Launcher-x86_64.AppImage";
              sha256 = "0qa5rrrmvxgy90lbpxjxsyf22wj1l5im0p4idizkdwb1cwc3rnjk";
            };
            })
          {}
        )
      ];
      my.home.shellAliases = { "agll" = "artix-games-launcher-latest"; };
    })
  
    # misc-byzanz
    (mkKnob [ "aurelius" ] {
      my.home.packages = [ pkgs.byzanz ];
    
      my.home.shellAliases = {
        "record-single" = "byzanz-record --exec 'sleep infinity'  -x 0 -y -0 -w 1920 -h 1080";
        "record-double" = "byzanz-record --exec 'sleep infinity'  -x 0 -y -0 -w 3840 -h 1080";
      };
    })
  
    # misc-android
    (mkKnob [ "aurelius" "seneca" ] {
      my.home.packages = with pkgs; [
        android-tools
        scrcpy
      ];
    
      my.home.shellAliases = {
        phone = "adb connect 192.168.1.4 && scrcpy";
      };
    })

    # misc-qjoypad-basedef
    (mkKnob [ "aurelius" "seneca" ] (let cfg = config.qjoypad; in with lib; {
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
    }))

    # misc-qjoypad-impl  
    (mkKnob [ "aurelius" "seneca" ] {
      qjoypad = {
        enable = true;
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
    })
  
    # wine-base
    (mkKnob [ "aurelius" ] {
      hardware.opengl.driSupport32Bit = true;
    
      my.home.packages = with pkgs; [
        wineWowPackages.staging
        winetricks
      ];
    })
  
    # wine-musicbee
    (mkKnob [ "aurelius" ] {
      my.home.packages = (
        let
          wpfx = "/home/ejg/musicbee";
        in with pkgs; [(
          writeShellScriptBin 
            "mb"
            ''
              WINEPREFIX=${wpfx} wine ${wpfx}/MusicBee.exe
            ''
        )]
      );
            
      # my.home.shellAliases."mb" = (
      #   let wpfx = "/home/ejg/musicbee"; 
      #   in "WINEPREFIX=${wpfx} wine ${wpfx}/MusicBee.exe"
      # );  
    })
  
    # games-steam
    (mkKnob [ "aurelius" ] {
      programs.steam.enable = true;
    })
  
    # misc-pyradio
    (mkKnob [ "aurelius" "seneca" ] {
      my.home.packages = [ pkgs.pyradio ];
    })
  ];
}

