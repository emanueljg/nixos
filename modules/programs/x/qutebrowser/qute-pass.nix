{ config, ... }:

{

  my.programs.qutebrowser.keyBindings.normal = {
    "zl" = "spawn --userscript qute-pass -U secret -u \"login: (.+)\" -d dmenu";
    "zpl" = "spawn --userscript qute-pass -U secret -u \"login: (.+)\" -w -d dmenu";
    "zul" = "spawn --userscript qute-pass -U secret -u \"login: (.+)\" -e -d dmenu";
  };

}
