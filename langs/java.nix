{ config, pkgs, ... }:

{
  # installs package and sets JAVA_HOME
  my = let pkg = pkgs.openjdk8; in {
    programs.java = {
      enable = true;
      package = pkg;
    };
    
    home.packages = with pkgs; [
      (gradle.override { java = pkg; })
      (jdt-language-server.override { jdk = pkg; })
      # required for helix to notice it
      (writeShellScriptBin "jdtls" "jdt-language-server")
    ];
  };
}
