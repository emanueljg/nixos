{ factorio-server, pkgs, nixpkgs-unstable, ... }: {

  imports = [ factorio-server.nixosModules.default ];

  services.factorio-server = {
    enable = true;
    package = nixpkgs-unstable.factorio-headless;
    openFirewall = true;
    socketUser = "ejg";
    extraConfig = {
      require_user_verification = false;
    };
  };

  # nixpkgs.config.allowUnfree = true;

}
  
