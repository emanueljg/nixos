{ lib }:


let
  inherit (lib.attrsets) mapAttrs recursiveUpdate genAttrs;
in 


{
  genDefault = keys: value:
    genAttrs 
      keys
      (k: value)
  ;

  doRecursiveUpdates = old: ass: mapAttrs (name: value: recursiveUpdate old value) ass;  
}
