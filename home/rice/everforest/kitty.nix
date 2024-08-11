{
  programs.kitty =
    let
      theme = import ./theme.nix;
    in
    {
      theme = theme.name;
      font = {
        name = "JetBrains Mono Regular Nerd Font Complete Mono";
        package = null;
        size = 18;
      };
    };
}

