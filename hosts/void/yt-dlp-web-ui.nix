{ nixosModules, ... }: {

  imports = [ nixosModules.yt-dlp-web-ui ];

  services.yt-dlp-web-ui = {
    enable = true;
    openFirewall = true;
    downloadDir = "/mnt/data/vids/yt";
    logging = true;
    rpcAuth = {
      enable = true;
      user = "ejg";
      insecurePasswordText = "password";
    };
  };
}
