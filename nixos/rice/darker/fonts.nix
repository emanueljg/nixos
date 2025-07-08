{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}

