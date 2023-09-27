{ config, pkgs, ... }: {

  my.home.packages = with pkgs; [ jmtpfs ];
  my.programs.bashmount = {
    enable = true;
  };

  my.home.shellAliases = let 
    realTgt = "/home/ejg/.phone";
    innerRealTgt = "'${realTgt}/Internal shared storage'";
    symlinkTgt = "/home/ejg/phone";
    ejgUid = "1000";
  in {
    "phm" = "mkdir -p ${realTgt} && sudo jmtpfs ${realTgt} -o allow_other && ln -sf ${innerRealTgt} ${symlinkTgt}";
    "phum" = "sudo fusermount -u ${realTgt} && rmdir ${realTgt} && rm ${symlinkTgt}";
  };
}
    
