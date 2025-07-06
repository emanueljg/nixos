{
  environment.shellAliases = {
    "..." = "cd ../..";

    "e" = "$EDITOR";

    "s" = "sudo";
    "se" = "sudoedit";

    "sd" = "sudo systemctl";
    "sds" = "sd start";
    "sdr" = "sd restart";
    "sdst" = "sd status";
    "sdj" = "sudo journalctl";
    "sdju" = "sdj -u";
    "sdjuf" = "sdj -fu";

    "rune" = "grep -rwne";

    "nfu" = "nix flake update";
    "nfc" = "nix flake check";
  };
}
