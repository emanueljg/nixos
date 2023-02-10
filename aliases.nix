{ config, ... }:

{
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

    "skk" = "kitty +kitten ssh";
    "aur" = "skk ejg@192.168.1.2 -p 34022";

    "aurt" = "deluge-console -d 192.168.1.2 -p 58846 -U ejg -P password";
    "aurti" = "aurt info";
    "aurta" = "aurt add";
    "aurtax" = "aurta $(xp)"; 
  
    "pling" = ''while :; do sleep 0.75 && echo -e "\a"; done''; 
  };
}
