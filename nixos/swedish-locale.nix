{ lib, ... }:
{
  time.timeZone = "Europe/Stockholm";
  console.keyMap = "sv-latin1";

  i18n =
    let
      en = "en_US.UTF-8";
      sv = "sv_SE.UTF-8";
    in
    {
      defaultLocale = en;
      extraLocaleSettings = lib.attrsets.genAttrs [
        "LC_TIME"
        "LC_MONETARY"
        "LC_PAPER"
        "LC_NAME"
        "LC_TELEPHONE"
      ] (lib.trivial.const sv);
    };
}
