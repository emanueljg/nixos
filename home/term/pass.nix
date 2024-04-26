{ pkgs
, ...
}:
# let
#   gnupg = pkgs.gnupg22.overrideAttrs (final: old: {
#     version = "2.2.27";

#     src = pkgs.fetchurl {
#       url = "mirror://gnupg/gnupg/${final.pname}-${final.version}.tar.bz2";
#       hash = "sha256-NOYACQFOoWQCBpE24KX2PZtl+QCWJEl121zqdLPQI5k=";
#     };

#     patches =
#       let
#         modPath = "${pkgs.path}/pkgs/tools/security/gnupg/";
#       in
#       [
#         (modPath + "fix-libusb-include-path.patch")
#         (modPath + "tests-add-test-cases-for-import-without-uid.patch")
#       ];
#   });
# in
{
  programs.password-store = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # home.

  home.shellAliases = {
    "psl" = "pass list";
    "psr" = "pass rm";
    "psi" = "pass insert";
    "psg" = "pass generate";
    "psim" = "psi -m";
    "pss" = "pass show";
    "psp" = "pass -c";
    "pse" = "pass edit";
  };
}
