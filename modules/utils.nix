let
  inherit
    (builtins)
    attrNames
    readDir
    mapAttrs
    filter
    split
    elemAt
    ;

in
rec {
  dirFiles = path: (
    map
      (f: path + ("/" + f))
      (
        filter
          (fn: (elemAt (split "_" fn) 0) != "")
          (attrNames (readDir path))
      )
  );

  systemify = system: rawInputs: (
    mapAttrs
      (_name: input: import input { inherit system; })
      rawInputs
  );

  defaultSystem = "x86_64-linux";

  hostSystem = host: host.system or defaultSystem;

  mkNixosConfigurations =
    { hosts
    , inputs
    , rawInputs
    ,
    }: (
      mapAttrs
        (_hostName: host:
        let
          system = hostSystem host;
        in
        rawInputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // (systemify system rawInputs);
          inherit (host) modules;
        })
        hosts
    );

  mkColmenaHosts = hosts: (
    mapAttrs
      (_hostName: host: {
        imports = host.modules;
        deployment = {
          allowLocalDeployment = true;
          targetUser = "ejg";
          targetHost = host.ip;
        };
      })
      hosts
  );

  mkColmenaSystemizeInputs = hosts: rawInputs: (
    mapAttrs
      (_hostName: host: systemify (hostSystem host) rawInputs)
      hosts
  );
}
