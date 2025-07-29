{
  local.nixos-rebuild = {
    enable = true;
    hosts = [
      {
        name = "void";
        key = "dv";
        cmd = "sudo nixos-rebuild switch --flake .#void";
      }
    ];
    # {
    #   name = "getsuga";
    #   key = "dg";
    #   cmd = "nixos-rebuild switch ---flake path:/home/ejg/nixos --target-host 'ejg@getsuga' --sudo";
    # }
  };
}
