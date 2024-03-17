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
    # ./i3.nix
    ./kitty.nix
    ./networkmanager.nix
    ./newsboat.nix
    ./nodejs.nix
    ./pavucontrol.nix
    ./phone.nix
    # ./picom.nix
    ./pkgs.nix
    # ./polybar.nix
    ./pyradio.nix
    ./python.nix
    ./qutebrowser
    ./rust.nix
    ./slack.nix
    ./slock.nix
    ./sound.nix
    ./terraform.nix
    ./virt.nix
    # ./x.nix
    ./ytfzf.nix
    ./yubikey.nix
    ./hyprland.nix
    ./wofi.nix
  ];

  custom = {
    hibernation.enable = lib.mkDefault true;
    stay-awake.enable = lib.mkDefault true;
  };

}
