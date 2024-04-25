{ pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellScriptBin "yt" "${ytfzf}/bin/ytfzf -D")
  ];
}
