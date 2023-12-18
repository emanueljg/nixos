{config, ...}: {
  my.programs.qutebrowser.keyBindings.normal = {
    # try to fill username / password
    "zl" = "spawn --userscript qute-pass -U secret -u \"user: (.+)\" -d dmenu";
    # try to fill password only
    "zpl" = "spawn --userscript qute-pass -U secret -u \"user: (.+)\" -w -d dmenu";
    # try to fill username only
    "zul" = "spawn --userscript qute-pass -U secret -u \"user: (.+)\" -e -d dmenu";
  };
}
