{
  inputs,
  modules,
  configs,
  lib,
  ...
}:
cfg:
let
  parent = configs.base;
in
{

  system = "x86_64-linux";

  specialArgs = lib.recursiveUpdate parent.specialArgs {
    packages = {
      inherit (inputs.nix-alien.packages.${cfg.system}) nix-alien;
    };
  };

  modules =
    parent.modules
    ++ (with modules; [
      # core
      networkmanager
      pavucontrol
      hw.bluetooth
      add-headphones-script

      # general software
      firefox
      qutebrowser
      tor-browser

      # wayland
      hyprland
      greetd
      swaylock
      pipewire
      wl-clipboard
      wofi
      waybar

      # multimedia
      mpv
      ffmpeg
      ani-cli
      yt-dlp
      qbittorrent
      pipe-viewer

      # customization
      rice.darker
      xdg
      cursor
      fontconfig

      # programming
      nix-alien
    ]);
}
