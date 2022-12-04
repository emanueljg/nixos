{ config, pkgs, ... }:

{
  # default shell
  users.users."ejg".shell = pkgs.zsh;
  # required for
  # https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];
  my.programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    autocd = true;
    # cdpath = [ ]  could try and add this later?
    # defaultKeymap  perhaps this too
    # dirHashes     definitely this, could be very useful
  
    localVariables = {
      PROMPT = "%n@%m:%~ $ ";
      #PROMPT="%F{68}%n@%m%f:%F{14}%~%f $ ";
    };
  };
}
  
