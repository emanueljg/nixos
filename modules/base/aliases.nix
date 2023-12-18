_: {
  my.home.shellAliases = {
    "c" = "cd /etc/nixos";
    "..." = "cd ../..";

    "e" = "$EDITOR";

    "s" = "sudo";
    "se" = "sudoedit";
    "si" = "s -i";

    "nrs" = "sudo nixos-rebuild switch";
    "nrt" = "sudo nixos-rebuild test";
    "lnk" = ''basename "$(readlink /etc/nixos/configuration.nix)" | sed 's/\(.*\).nix/\1/g' '';

    "xc" = "xclip -sel clip";
    "xp" = "xc -o";

    # pipe into this to save stdin as a paste. The sed remove a trailing null char.
    "tb" = "nc termbin.com 9999 | sed 's/\\x0//' | tee >(xc -rmlastnl)";

    "g" = "git";

    "gs" = "g status";

    "gb" = "g branch";
    "gbd" = "gb -d";

    "gch" = "g checkout";
    "gchb" = "g checkout -b";

    "gm" = "g merge";

    "ga" = "g add";

    "gco" = "g commit -m";
    "gcoa" = "g commit -am";

    "gpush" = "g push";
    "gpull" = "g pull";

    "gl" = "g log";
    "gd" = "g diff";

    "pling" = ''while :; do sleep 0.75 && echo -e "\a"; done'';

    "sd" = "sudo systemctl";
    "sds" = "sd start";
    "sdr" = "sd restart";
    "sdst" = "sd status";
    "sdj" = "sudo journalctl";
    "sdju" = "sdj -u";
    "sdjuf" = "sdj -fu";

    "rune" = "grep -rwne";
  };
}
