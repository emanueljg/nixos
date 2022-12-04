{ lib }:

let 
  inherit (lib.attrsets)
    mapAttrs
    recursiveUpdate
  ;
in {
  # "sprid ut"
  doRecursiveUpdates = lhs: asas: 
    mapAttrs 
      (name: value: recursiveUpdate lhs value) 
      asas
  ;  

  # "plussa på"
  updateAttrs = ass: old: 
    lib.foldl 
      (lhs: rhs: recursiveUpdate lhs rhs) 
      old 
      ass
  ;
}

