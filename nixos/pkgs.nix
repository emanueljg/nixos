{ pkgs, packages, ... }:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      xterm
      wget
      acpi
      htop
      zip
      unzip
      efibootmgr
      parted
      tree
      tldr
      jq
      comma
      btop
      feh
      mupdf
      openssl
      nix-output-monitor
      ;
  };
}
