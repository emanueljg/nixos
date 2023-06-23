let 
  hosts = {
    "seneca" = {
      ip = "localhost";
    };

    "crown" = {
      ip = "192.168.0.2";
    };
  
    "void" = {
      ip = "128.0.0.1"; 
    };

    "fenix" = {
      ip = "95.217.219.33";
    };
  };

  defaultSystem = "x86_64-linux";

in {
  inherit hosts;
  mkHostOutputs = inputs: rec {
    nixosConfigurations = builtins.mapAttrs (name: value: 
      let 
        defaults = { 
          modules = import ./hosts/${name};
          system = defaultSystem;
          specialArgs = inputs;
        };
        attrs = { inherit (defaults // value) modules system specialArgs; };
      in inputs.nixpkgs.lib.nixosSystem attrs
    ) hosts;   

    deploy.nodes = builtins.mapAttrs (name: value: 
      let 
        system = value.system or defaultSystem;
        deployFunc = inputs.deploy-rs.lib.${system}.activate.nixos;
        defaults = { 
          user = "root";
          path = deployFunc nixosConfigurations.${name}; 
        };
      in { 
        hostname = name;
        profiles.system = { 
          inherit (defaults // value) user path; 
        }; 
      }
    ) hosts;   
  };
}


  
