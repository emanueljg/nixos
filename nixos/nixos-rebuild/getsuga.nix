{
  local.nixos-rebuild = {
    enable = true;
    hosts = [
      {
        name = "getsuga";
        key = "dg";
        cmd = "sudo nixos-rebuild switch --flake .#getsuga";
      }
      {
        name = "void";
        key = "dv";
        cmd = "nixos-rebuild switch --flake .#void --target-host 'ejg@void' --sudo";
      }
    ];
  };
}
