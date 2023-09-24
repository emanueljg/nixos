{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xterm
    wget
    acpi
    htop
    zip
    unzip
    efibootmgr
    parted
    tree
    openssl
    tldr
    jq
    comma
  ];
}


