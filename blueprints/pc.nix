with (import ../lib/funcs.nix); mkbp {
  "blueprints" = [ "core.nix" ];
  "modules" = [ 
    "meta/colmena.nix"

    "hardware/sound.nix"
    "hardware/bluetooth.nix"

    "programs/langs/python.nix"
    "programs/langs/go.nix"

    "programs/networkmanager.nix"
    "programs/pass.nix"
    "programs/jq.nix"
    "programs/discordo.nix"
    "programs/ytfzf.nix"
    "programs/ani-cli.nix"
    "programs/email.nix"

      "programs/x/x.nix"
      "programs/x/i3.nix"
      "programs/x/pywal"
      #"programs/x/st"
      "programs/x/kitty.nix"
      "programs/x/qutebrowser"

      "programs/x/tauon.nix"

    "pkglists/misc-pkgs.nix"
    "pkglists/kitchensink.nix"
  ];
}


