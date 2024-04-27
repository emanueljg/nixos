{ pkgs
, sops-nix
, ...
}: {
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  environment.systemPackages = [
    pkgs.sops
  ];
}
