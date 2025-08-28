{ pkgs, ... }:
{
  environment = {
    systemPackages = [
      pkgs.pass
    ];
    sessionVariables = {
      PASSWORD_STORE_DIR = "/home/ejg/.local/share/password-store";
    };
    shellAliases = {
      "psl" = "pass list";
      "psr" = "pass rm";
      "psi" = "pass insert";
      "psg" = "pass generate";
      "psim" = "psi -m";
      "pss" = "pass show";
      "psp" = "pass -c";
      "pse" = "pass edit";
    };
  };
}
