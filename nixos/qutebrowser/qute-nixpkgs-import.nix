{ pkgs, lib, ... }:
{
  local.programs.qutebrowser.keyBindings.normal =
    let
      script = pkgs.writeShellApplication {
        name = "qute-nixpkgs-import";
        runtimeInputs = [
          pkgs.wl-clipboard
          pkgs.xclip
        ];
        text = ''
          # QUTE_URL="https://github.com/NixOS/nixpkgs/blob/4196e2ce85413d7f21a7ac932bfcf0ad70d2ef01/pkgs/by-name/vi/vintagestory/package.nix"
          # after the 6th / and the 7th /, we find the commit hash
          commit="$(echo "$QUTE_URL" | cut -d '/' -f7)"

          if [ -z "$WAYLAND_DISPLAY" ]; then
            echo "running x"
            copier=xclip
          else
            echo "running wayland"
            copier=wl-copy
          fi

          $copier << EOF
          pkgsGit = (import
            (builtins.fetchTarball {
              url = "https://github.com/nixos/nixpkgs/archive/$commit.tar.gz";
              sha256 = lib.fakeHash;
            })
            {
              inherit (pkgs) system;
            }
          );
          EOF
        '';
      };
    in
    {
      ",nimp" = "spawn --userscript ${lib.getExe script}";
    };
}
