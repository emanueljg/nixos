{
  inputs = {
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.49.0";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.49.0";
      inputs.hyprland.follows = "hyprland";
    };

    archiver = {
      url = "github:emanueljg/archiver";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      # not overriden, see:
      # https://github.com/thiagokokada/nix-alien?tab=readme-ov-file#nixos-installation-with-flakes
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # private
    # vidya.url = "github:emanueljg/vidya";
    vidya.url = "path:/home/ejg/dev/vidya";

  };

  outputs =
    { self, nixos-unstable, ... }@inputs:
    let
      inherit (nixos-unstable) lib;
    in
    {
      modules =
        let
          modulesToAttrs =
            cursor:
            let
              paths = builtins.readDir cursor;
            in
            if paths ? "default.nix" then
              (import cursor)
            else
              (lib.filterAttrsRecursive (_: v: v != null) (
                lib.mapAttrs' (
                  n: v:
                  lib.nameValuePair (if v == "regular" then (lib.removeSuffix ".nix" n) else n) (
                    if v == "regular" && !(lib.hasSuffix ".nix" n) then
                      null
                    else if v == "regular" then
                      (import "${cursor}/${n}")
                    else if v == "directory" then
                      (modulesToAttrs "${cursor}/${n}")
                    else
                      (builtins.throw "")
                  )
                ) paths
              ));
        in
        modulesToAttrs ./nixos;

      configs =
        let
          cfgDir = ./cfgs;
        in
        lib.mapAttrs' (
          n: v:
          lib.nameValuePair (lib.removeSuffix ".nix" n) (
            let
              x = (
                (import "${cfgDir}/${n}") {
                  inherit inputs lib self;
                  inherit (self) modules configs;
                }
              );
            in
            if builtins.isFunction x then lib.fix x else x
          )
        ) (builtins.readDir cfgDir);

      nixosConfigurations = builtins.mapAttrs (_: v: lib.nixosSystem v) self.configs;
      formatter = builtins.mapAttrs (_: pkgs: pkgs.nixfmt-rfc-style) nixos-unstable.legacyPackages;
    };
}
