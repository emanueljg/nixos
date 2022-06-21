{ lib }:


let
  inherit (lib.lists)
    foldl
  ;

  inherit (lib.attrsets) 
    mapAttrs 
    recursiveUpdate 
    genAttrs
  ;
in 


{
  genDefault = keys: value:
    genAttrs 
      keys
      (k: value)
  ;

  doRecursiveUpdates = old: ass: mapAttrs (name: value: recursiveUpdate old value) ass;  

  updateAttrs = ass: old: foldl (rhs: lhs: recursiveUpdate lhs rhs) old ass;
}
