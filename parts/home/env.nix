{
  imports = [
    ./hm.nix
  ];
  my = {
    # enable current shell to allow HM to inject stuff
    programs.bash.enable = true;
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
      };
      shellAliases = {
        "c" = "cd /config";
        "..." = "cd ../..";
        "e" = "$EDITOR";
        "s" = "sudo";
        "se" = "sudoedit";
        "si" = "sudo -i";
        "nrs" = "sudo nixos-rebuild switch";
        "nrt" = "sudo nixos-rebuild test";
      };
    };
  };
}
