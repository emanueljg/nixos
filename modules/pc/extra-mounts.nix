{pkgs, ...}: {
  my = {
    home = {
      packages = with pkgs; [jmtpfs];
      shellAliases = let
        realTgt = "/home/ejg/.phone";
        innerRealTgt = "'${realTgt}/Internal shared storage'";
        symlinkTgt = "/home/ejg/phone";
      in {
        "phm" = "mkdir -p ${realTgt} && sudo jmtpfs ${realTgt} -o allow_other && ln -sf ${innerRealTgt} ${symlinkTgt}";
        "phum" = "sudo fusermount -u ${realTgt} && rmdir ${realTgt} && rm ${symlinkTgt}";
      };
    };
    programs.bashmount.enable = true;
  };
}
