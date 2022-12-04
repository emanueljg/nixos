{ config, pkgs, lib, ... }:

let 
  cfg = config.custom;
  inherit (import /config/ark/funcs.nix { inherit lib; })
    doRecursiveUpdates
    updateAttrs
  ;  
in with lib; {
  options.custom = rec {
    defaultMonitor = mkOption {
      description = "defaut pseudo monitor that all other monitors update";
      type = with types; submodule {
        options = {
          autorandr = mkOption {
            type = attrs;
          };
          
          workspaces = mkOption {
            type = listOf int;
            default = range 1 10;
          };

          bars = mkOption {
            type = attrs;
          };            
        };
      };
    };
          
    monitors = mkOption {
      description = "all monitors";
      type = types.attrsOf defaultMonitor.type;
      apply = (ms:
        doRecursiveUpdates
          config.custom.defaultMonitor
          ms
      );
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

      COLORS = import /config/ark/colors.nix;
      inherit (import /config/ark/misc-constants.nix) BAR-HEIGHT;
    in {       
      my.services.polybar.settings = (
        doRecursiveUpdates 
          ({
            bottom = true;
            background = COLORS.PRIMARY;
            foreground = COLORS.TERTIARY;
            override-redirect = true;
            wm-restack = "i3";
            height = BAR-HEIGHT;
            offset.y = 20;
            # radius = 0;
            font = [ 
              "JetBrains Mono:pixelsize=16:weight=bold;3" 
              "Material Design Icons:size=18:style=Regular;3"
            ];
            locale = config.i18n.extraLocaleSettings.LC_TIME;
          })
        
          (
            updateAttrs 
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
}
