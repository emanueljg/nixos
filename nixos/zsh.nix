{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    vteIntegration = true;
  };
  environment.variables = {
    LS_COLORS = "$(${lib.getExe pkgs.vivid} generate nord)";
    PROMPT = "%n@%m:%~ $ ";
  };
}
