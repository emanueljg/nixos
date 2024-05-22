{ config, ... }: {
  home.shellAliases = {
    "c" = "cd /etc/nixos";
    "..." = "cd ../..";

    "e" = "$EDITOR";

    "s" = "sudo";
    "se" = "sudoedit";
    "si" = "s -i";

    "nrs" = "sudo nixos-rebuild switch --flake path:${config.home.homeDirectory}/nixos#";
    "nrt" = "sudo nixos-rebuild test";
    "bld" = "nrs && hm";
    "lnk" = ''basename "$(readlink /etc/nixos/configuration.nix)" | sed 's/\(.*\).nix/\1/g' '';

    "xc" = "xclip -sel clip";
    "xp" = "xc -o";

    # pipe into this to save stdin as a paste. The sed remove a trailing null char.
    "tb" = "nc termbin.com 9999 | sed 's/\\x0//' | tee >(xc -rmlastnl)";

    "pling" = ''while :; do sleep 0.75 && echo -e "\a"; done'';

    "sd" = "sudo systemctl";
    "sds" = "sd start";
    "sdr" = "sd restart";
    "sdst" = "sd status";
    "sdj" = "sudo journalctl";
    "sdju" = "sdj -u";
    "sdjuf" = "sdj -fu";

    "rune" = "grep -rwne";

    "nflu" = "nix flake lock --update-input";
    "nfu" = "nix flake update";
    "nfc" = "nix flake check";

    "bt-hp" = "bluetoothctl connect 5C:EB:68:79:BA:6F";
    "bt-dc" = "bluetoothctl disconnect";
  };
}
