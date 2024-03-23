{ lib, ... }: {
  imports = [
    ../base

    ./stay-awake.nix
    ./hibernation.nix

    ./ani-cli.nix
    ./bluetooth.nix
    ./docker.nix
    ./extra-mounts.nix
    ./f5fpc.nix
    ./firefox.nix
    ./go.nix
    ./kitty.nix
    ./networkmanager.nix
    ./newsboat.nix
    ./nodejs.nix
    ./pavucontrol.nix
    ./phone.nix
    ./pkgs.nix
    ./pyradio.nix
    ./python.nix
    ./qutebrowser
    ./rust.nix
    ./slack.nix
    ./slock.nix
    ./sound.nix
    ./terraform.nix
    ./virt.nix
    ./ytfzf.nix
    ./yubikey.nix
  ];

  custom = {
    hibernation.enable = lib.mkDefault true;
    stay-awake.enable = lib.mkDefault true;
  };

}
