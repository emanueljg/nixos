{ config, lib, ... }:

let
  inherit (builtins) 
    map
    concatMap
    listToAttrs
  ;

  inherit (lib.attrsets)
    mapAttrs
    mapAttrs'
    mapAttrsToList
    cartesianProductOfSets
    nameValuePair
  ;

  inherit (lib.strings)
    escape
  ;
in

rec {
  getSetting = string: config.my.services.polybar.settings.${string};
  makeXAdjusted = adj: int: adj // { offset-x = int; };  

  makeAbsoluteLeft = adj: makeXAdjusted adj 20;
  makeAbsoluteRight = adj: makeXAdjusted adj (1920 - 20 - adj.width);

  makeRelativeOfWrapper = f: abs: adj: f abs adj;
  makeRightOf = abs: adj: makeRelativeOfWrapper (abs: adj: makeXAdjusted adj (abs.offset-x + abs.width + 20)) abs adj;  
  makeLeftOf = abs: adj: makeRelativeOfWrapper (abs: adj: makeXAdjusted adj (abs.offset-x - 20 - adj.width)) abs adj; 

  applyToEachMonitor = bars:   
    listToAttrs (
      concatMap (m: 
        mapAttrsToList (name: value:
          nameValuePair ("bar/" + name + "-" + m) (value // { monitor = "\${env:MONITOR:" + m + "}"; }) 
        ) bars
      ) [ "DVI-I-2-2" "DVI-I-1-1" "eDP-1" ]   
    );
}

