{ pkgs, ... }: { 
  my.home.packages = with pkgs; [ 
    nix-index
    comma
  ];
}
