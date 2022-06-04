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
        "si" = "s -i";

        "nrs" = "sudo nixos-rebuild switch";
        "nrt" = "sudo nixos-rebuild test";

        "skk" = "kitty +kitten ssh";
        "aur" = "skk ejg@192.168.1.2 -p 34022";

        "g" = "git";
        "gs" = "g status";
        "ga" = "g add";
        "gc" = "g commit -m";
        "gca" = "g commit -am";
        "gpush" = "g push";
        "gpull" = "g pull";
      };
    };
  };
}
