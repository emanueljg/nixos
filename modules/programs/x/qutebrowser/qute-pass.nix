{ config, ... }:

{

  my.programs.qutebrowser.keyBindings.normal = {
    "zl" = "spawn --userscript qute-pass -U secret -u \"user: (.+)\" -d dmenu";
    "zpl" = "spawn --userscript qute-pass -U secret -u \"user: (.+)\" -w -d dmenu";
    "zul" = "spawn --userscript qute-pass -U secret -u \"user: (.+)\" -e -d dmenu";
  };

}
