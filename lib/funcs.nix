with builtins; let
  mkcollection = as: let 
    path = ../.;
    modules = (map
      (x: path + ("/modules/" + x))
      as."modules"
    );
    nestedBps = (map
      (x: path + ("/blueprints/" + x))  
      as."blueprints"
    );
    bpMods = concatMap (x: import x) nestedBps;
  in modules ++ bpMods;
in {
  # alias; we might change this implementation later,
  # but for now it's just a literal mkcollection call.
  mkbp = as: mkcollection as;

  mkhost = host: as: (
    mkcollection as
    ++
    [ (../hosts + "/${host}/configuration.nix") ]
  );
}

