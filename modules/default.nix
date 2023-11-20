rec {
  utils = import ./utils.nix;

  abstract = rec {
    base = utils.dirFiles ./base;
    pc = base ++ utils.dirFiles ./pc;
  };

  hosts = with abstract; utils.mkModules {
    # disable for now
    # "crown" = {
    #   # ip = "192.168.0.2";
    #   extraModuleDirs = [ pc ];
    #   extraModules = [
    #     ./uses-efi-grub.nix
    #     ./mailserver/server.nix
    #   ];
    # };

    "void" = {
      ip = "192.168.0.3";
      extraModuleDirs = [ pc ];
      extraModules = [ 
        ./uses-efi-grub.nix
        ./can-hibernate.nix
        ./mailserver/client.nix
        ./uses-nvidia.nix
      ];
    };

    "seneca" = {
      ip = "192.168.0.4";
      extraModuleDirs = [ pc ];
      extraModules = [ 
        ./uses-efi-grub.nix
        ./can-hibernate.nix
      ];
    };

    "fenix" = {
      ip = "95.217.219.33";
      extraModuleDirs = [ base ];
    };

    "oakleaf" = {
      ip = "127.0.0.1";
      extraModuleDirs = [ pc ];
      extraModules = [ 
        ./uses-efi-grub.nix
        ./can-hibernate.nix
      ];
    };
    "stoneheart" = {
      ip = "127.0.0.1";
      extraModuleDirs = [ pc ];
      extraModules = [ 
        ./uses-efi-grub.nix
        ./uses-nvidia.nix
      ];
    };
  };

}