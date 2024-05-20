{ lib, pkgs, config, ... }: {
  options.programs.pyradio = {
    enable = lib.mkEnableOption "pyradio";
    package = lib.mkPackageOption pkgs "pyradio" { };

    playlists = lib.mkOption {
      description = ''
        Playlists to add to Pyradio. 
      '';
      default = { };
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stations = lib.mkOption {
            description = ''
              Stations to add to the playlist.
            '';
            type = lib.types.listOf (lib.types.submodule {
              options = {
                name = lib.mkOption {
                  description = ''
                    Name of the station.
                  '';
                  type = lib.types.str;
                };
                url = lib.mkOption {
                  description = ''
                    URL of the station.
                  '';
                  type = lib.types.str;
                };
              };
            });
          };
        };
      });
    };
    themes = lib.mkOption {
      description = ''
        Themes to add to Pyradio.
      '';
      default = { };
      type =
        let
          colorType = lib.types.strMatching "#[a-zA-Z0-9]{6}";
          mkColorOption = someGround: lib.mkOption {
            description = ''
              ${someGround} color in hex.
            '';
            type = colorType;
          };
          mkFgOption = mkColorOption "Foreground";
          mkBgOption = mkColorOption "Background";

          mkFgColorSubmod = description: lib.mkOption {
            inherit description;
            default = { };
            type = lib.types.submodule {
              options.fg = mkFgOption;
            };
          };

          mkFgBgColorSubmod = description: lib.mkOption {
            inherit description;
            default = { };
            type = lib.types.submodule ({ ... }@colorSubmod: {
              options = {
                fg = mkFgOption;
                bg = mkBgOption;

                _merged = lib.mkOption {
                  readOnly = true;
                  internal = true;
                  type = lib.types.str;
                  default = with colorSubmod.config; "${fg} ${bg}";
                };
              };
            });
          };
        in
        lib.types.attrsOf (lib.types.submodule ({ ... }@submod: {
          options = {
            station = lib.mkOption {
              description = ''
                Colors of stations.
              '';
              default = { };
              type = lib.types.submodule {
                options = {
                  normal = mkFgBgColorSubmod ''
                    Main foreground and background of stations.
                  '';
                  active = mkFgColorSubmod ''
                    Playing station text color. Background color will come from `station.normal`.
                  '';
                };
              };
            };
            statusBar = mkFgBgColorSubmod ''
              Colors of the status bar.
            '';
            cursor = lib.mkOption {
              description = ''
                Colors of the cursor.
              '';
              default = { };
              type = lib.types.submodule {
                options = {
                  normal = mkFgBgColorSubmod ''
                    Normal cursor colors.
                  '';
                  active = mkFgBgColorSubmod ''
                    Cursor colors for the playing station.
                  '';
                  edit = mkFgBgColorSubmod ''
                    Cursor colors for the line editor.
                  '';
                };
              };
            };
            extraFunc = mkFgColorSubmod ''
              Text color of extra function indication,
              like jump numbers within the status bar.
              Background color will come from station.normal.
            '';
            pyradioUrl = mkFgColorSubmod ''
              Text color of the pyradio URL.
            '';
            messagesBorder = lib.mkOption {
              description = ''
                Colors for message window border. Background can be left unset.
              '';
              default = { };
              type = lib.types.submodule ({ ... }@msgBorder: {
                options = {
                  fg = mkFgOption;
                  bg = lib.mkOption {
                    default = null;
                    type = with lib.types; nullOr colorType;
                  };
                  _merged = lib.mkOption {
                    readOnly = true;
                    internal = true;
                    type = lib.types.str;
                    default = with msgBorder.config;
                      if bg == null then fg else "${bg} ${fg}";
                  };

                };
              });
            };
            transparency = lib.mkOption {
              description = ''
                Theme transparency.
                  0: No transparency
                  1: Theme is transparent
                  2: Obey config setting (default)
              '';
              type = lib.types.ints.between 0 2;
              default = 0;
            };
          };
        }));
    };

    settings = lib.mkOption {
      description = ''
        Pyradio settings.
      '';
      default = { };
      type = lib.types.submodule {
        options = {

          player = lib.mkOption {
            description = ''
              The players to use, falling back in order.
            '';
            type = with lib.types; listOf str;
            default = [
              "mpv"
              "mplayer"
              "vlc"
            ];
          };

          mouse = lib.mkEnableOption "the mouse";

          station = lib.mkOption {
            description = ''
              Station-specific settings.
            '';
            default = { };
            type = lib.types.submodule {
              options = {
                autoPlay = lib.mkOption {
                  description = ''
                    Station autoplay settings.
                  '';
                  default = { };
                  type = lib.types.submodule {
                    options = {
                      enable = lib.mkEnableOption "station auto play";
                      randomize = lib.mkOption {
                        description = ''
                          Whether the auto-playing station should be chosen randomly.
                        '';
                        type = lib.types.bool;
                        default = false;
                      };
                      default = lib.mkOption {
                        description = ''
                          The station to autoplay. Ignored if autoplay is set to be random.
                        '';
                        type = lib.types.ints.positive;
                      };
                    };
                  };
                };

                confirmDelete = lib.mkOption {
                  description = ''
                    Whether to confirm the deletion of stations.
                  '';
                  type = lib.types.bool;
                  default = true;
                };
                useIcon = lib.mkOption {
                  description = ''
                    Whether to use the station icon in things like notifications.
                  '';
                  type = lib.types.bool;
                  default = true;
                };
                forceHttp = lib.mkEnableOption "force_http";
                connectionTimeout = lib.mkOption {
                  description = ''
                    Connection timeout settings.
                  '';
                  default = { };
                  type = lib.types.submodule {
                    options = {
                      enable = lib.mkOption {
                        description = ''
                          Whether to enable connection timeout.
                        '';
                        type = lib.types.bool;
                        default = true;
                      };
                      interval = lib.mkOption {
                        description = ''
                          How long in seconds to wait until connection times out.
                        '';
                        type = lib.types.ints.positive;
                        default = 10;
                      };
                    };
                  };
                };
              };
            };
          };

          playlist = lib.mkOption {
            description = ''
              Playlist-specific settings.
            '';
            default = { };
            type = lib.types.submodule {
              options = {
                default = lib.mkOption {
                  description = ''
                    The default playlist to show on startup.
                  '';
                  type = lib.types.str;
                  default = "stations";
                };
                confirmReload = lib.mkOption {
                  description = ''
                    Whether to confirm reloading of playlists.
                  '';
                  type = lib.types.bool;
                  default = true;
                };
                autoSave = lib.mkOption {
                  description = ''
                    Whether to autosave playlists.
                  '';
                  type = lib.types.bool;
                  default = false;
                };
              };
            };
          };


          notifications = lib.mkOption {
            description = ''
              Notifications-specific settings.
            '';
            default = { };
            type = lib.types.submodule {
              options = {
                enable = lib.mkEnableOption "notifications";
                interval = lib.mkOption {
                  description = ''
                    Interval of pyradio notifications. Set to null for no repetition.
                    Set to a number to repeat X seconds.
                  '';
                  type = with lib.types; nullOr int.positive;
                  default = null;
                };
              };
            };
          };

          ui = lib.mkOption {
            description = ''
              UI-specific settings.
            '';
            default = { };
            type = lib.types.submodule {
              options = {
                theme = lib.mkOption {
                  description = ''
                    The theme to use.
                    Builtin themes:
                      dark (default) (8 colors)
                      light (8 colors)
                      dark_16_colors (16 colors dark theme alternative)
                      light_16_colors (16 colors light theme alternative)
                      black_on_white (bow) (256 colors)
                      white_on_black (wob) (256 colors)
                    If theme is watched for changes, prepend its name
                    with an asterisk (i.e. '*my_theme')
                    This is applicable for user themes only!
                  '';
                  type = lib.types.str;
                  default = "dark";
                };
                transparency = lib.mkOption {
                  description = ''
                    Transparency-specific settings.
                  '';
                  default = { };
                  type = lib.types.submodule {
                    options = {
                      use = lib.mkEnableOption "use_transparency";
                      force = lib.mkEnableOption "force_transparency";
                    };
                  };
                };
                calculatedColorFactor = lib.mkOption {
                  description = ''
                    Produces Secondary Windows background color.
                    0 disables, otherwise lightens/darkens the base color.
                  '';
                  type = lib.types.numbers.between 0 0.2;
                  default = 0;
                };
              };
            };
          };

          remoteControlServer = lib.mkOption {
            description = ''
              A simple http server that can accept remote connections
              and pass commands to Pyradio.
            '';
            default = { };
            type = lib.types.submodule {
              options = {
                ip = lib.mkOption {
                  description = ''
                    IP of the server.
                  '';
                  type = lib.types.str;
                  default = "localhost";
                };
                port = lib.mkOption {
                  description = ''
                    Port of the server.
                  '';
                  type = lib.types.port;
                  default = 9998;
                };
                autoStart = lib.mkOption {
                  description = ''
                    Whether to autostart the server.
                  '';
                  type = lib.types.bool;
                  default = false;
                };
              };
            };
          };

          _distro = lib.mkOption {
            readOnly = true;
            internal = true;
            type = lib.types.str;
            default = "NixOS";
          };
        };
      };
    };
  };


  config =
    let
      cfg = config.programs.pyradio;
      pyBool = bool: if bool then "True" else "False";

      playlistFiles = lib.mapAttrs'
        (name: value: lib.nameValuePair
          ("pyradio/${name}.csv")
          ({
            text = lib.concatStringsSep "\n" (
              builtins.map (station: "${station.name},${station.url}") value.stations
            );
          })
        )
        cfg.playlists;

      themeFiles = lib.mapAttrs'
        (name: theme: lib.nameValuePair
          ("pyradio/themes/${name}.pyradio-theme")
          ({
            text =
              ''
                Stations           ${theme.station.normal._merged}         
                Active Station     ${theme.station.active.fg}

                Status Bar         ${theme.statusBar._merged}

                Normal Cursor      ${theme.cursor.normal._merged}
                Active Cursor      ${theme.cursor.active._merged}
                Edit Cursor        ${theme.cursor.edit._merged}

                Extra Func         ${theme.extraFunc.fg}

                PyRadio URL        ${theme.pyradioUrl.fg}

                Messages Border    ${theme.messagesBorder._merged}

                transparency       ${builtins.toString theme.transparency}
              '';
          })
        )
        cfg.themes;
    in
    lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];
      xdg.configFile = playlistFiles // themeFiles // {
        "pyradio/config".text = ''
          # Generated by Nix, do not edit!
        
          # cfg.player
          player = ${lib.concatStringsSep ", " cfg.settings.player}

          # cfg.mouse
          enable_mouse = ${pyBool cfg.settings.mouse}

          # cdg.station 
          default_station = ${
            if !cfg.settings.station.autoPlay.enable then "False" else (
              if cfg.settings.station.autoPlay.randomize then "Random" else (
                cfg.settings.station.autoPlay.default
              )
            )
          }
          confirm_station_deletion = ${pyBool cfg.settings.station.confirmDelete}
          use_station_icon = ${pyBool cfg.settings.station.useIcon}
          force_http = ${pyBool cfg.settings.station.forceHttp}
          connection_timeout = ${
            if !cfg.settings.station.connectionTimeout.enable then "0" else (
              builtins.toString cfg.settings.station.connectionTimeout.interval
            )
          }

          # cfg.settings.playlist
          default_playlist = ${cfg.settings.playlist.default}
          confirm_playlist_reload = ${pyBool cfg.settings.playlist.confirmReload}
          auto_save_playlist = ${pyBool cfg.settings.playlist.autoSave}

          # cfg.settings.notifications
          enable_notifications = ${
            if !cfg.settings.notifications.enable then "-1" else (
              if (cfg.settings.notifications.interval == null) then 0 else (
                cfg.settings.notifications.interval
              )
            )
          }

          # cfg.settings.ui
          theme = ${cfg.settings.ui.theme}
          use_transparency = ${pyBool cfg.settings.ui.transparency.use}
          force_transparency = ${pyBool cfg.settings.ui.transparency.force}
          calculated_color_factor = ${builtins.toString cfg.settings.ui.calculatedColorFactor}

          # cfg.settings.remoteControlServer
          remote_control_server_ip = ${cfg.settings.remoteControlServer.ip}
          remote_control_server_port = ${builtins.toString cfg.settings.remoteControlServer.port}
          remote_control_server_auto_start = ${pyBool cfg.settings.remoteControlServer.autoStart}

          # cfg.settings._distro (automatically generated)
          distro = ${cfg.settings._distro}
        '';
      };
    };
}
    
