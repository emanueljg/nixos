rec {
  utils = import ./utils.nix;

  abstract = rec {
    base = utils.dirFiles ./base;
    pc = base ++ utils.dirFiles ./pc;
  };

  mkHosts = { inputs ? { } }: with abstract;
    utils.mkModules rec {

      "void" = {
        ip = "192.168.0.3";
        extraModuleDirs = [ base ];
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

      "_oakleaf" = {
        ip = "127.0.0.1";
        extraModuleDirs = [ pc ];
        extraModules = [
          ./uses-efi-grub.nix
          ./can-hibernate.nix
        ];
      };

      "oakleaf-home" = _oakleaf // {
        extraModuleDirs = _oakleaf.extraModuleDirs ++ [
          (utils.dirFiles ./oakleaf)
        ];
        extraModules = _oakleaf.extraModules ++ [
          ./oakleaf/_spec-home.nix
        ];
      };

      "oakleaf-laptop" = _oakleaf // {
        extraModuleDirs = _oakleaf.extraModuleDirs ++ [
          (utils.dirFiles ./oakleaf)
        ];
        extraModules = _oakleaf.extraModules ++ [
          ./oakleaf/_laptop-pape.nix
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
      "weasel" = {
        ip = "127.0.0.1";
        extraModuleDirs = [ base ];
        extraModules = [
          inputs.wsl.nixosModules.default
        ];
      };
    };
}
