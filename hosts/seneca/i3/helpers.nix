{ config, lib }:

let
  inherit (builtins)
    map
    attrNames
    hasAttr
    toString
    mapAttrs
  ;

  inherit (lib.strings)
    concatMap
    concatMapStrings
    removePrefix
  ;

  inherit (lib.lists)
    flatten
    range
  ;

  inherit (lib.attrsets)
    filterAttrs
    mapAttrsToList
    genAttrs
  ;

  inherit (import ../../../helpers.nix { inherit lib; })
    doRecursiveUpdates
    genDefault
  ;

  inherit (import ../../constants.nix)
    GAP
    COLORS
  ;
in

{ 
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

  genWorkspaceOutputs = outputRanges:
    flatten
      (mapAttrsToList 
        (output: workspaces: 
          (map 
            (workspace: { "output" = output; "workspace" = toString workspace; }) 
            workspaces
          )
        )
        outputRanges
      )
  ;

  genColors = border-focused: indicator: border-unfocused:
    mapAttrs 
      (name: value: value // { childBorder = value.border; } )
      (doRecursiveUpdates
        { background = COLORS.black; text = COLORS.black; }
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
}

