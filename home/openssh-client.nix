{ lib, pkgs, ... }: {
  programs.ssh = {
    enable = true;
    package = pkgs.openssh; # how on earth is this not default
    matchBlocks = {
      "void" = {
        hostname = "emanueljg.com";
        user = "ejg";
      };
    };
  };
}
		
