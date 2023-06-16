{ pkgs, ... }: { 
  my.home.packages = with pkgs; [ 
    ytfzf
    (writeShellScriptBin "yt" "${ytfzf}/bin/ytfzf -D")
  ];
}
