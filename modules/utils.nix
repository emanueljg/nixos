let
  inherit (builtins)
    attrNames
    readDir
    mapAttrs
    concatMap
    isList
    filter
    split
    elemAt
  ;

  flatten = x:
    if isList x
    then concatMap (y: flatten y) x
    else [x];

in rec {
  dirFiles = path: (
    map 
      (f: path + ("/" + f)) 
      (filter 
        (fn: (elemAt (split "_" fn) 0) != "")
        (attrNames (readDir path))
      )
  );  

  mkModules = hosts: ( 
    mapAttrs 
      (hostName: host: 
        host // { 
          modules = (host.extraModules or [])
            ++ (flatten (host.extraModuleDirs or [])) 
            ++ (dirFiles (./. + ("/" + hostName)));
        }
      )
    hosts
  );

  mkNixosConfigurations = { hosts, nixpkgs, attrs }: (
    mapAttrs
      (hostName: host: nixpkgs.lib.nixosSystem {
        system = (host.system or "x86_64-linux");
        specialArgs = attrs;
        modules = host.modules;
      })
      hosts
  );

  mkColmenaHosts = hosts: (
    mapAttrs
      (hostName: host: {
        imports = host.modules;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = host.ip;
        };
      })
      hosts
  );
}


