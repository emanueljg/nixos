{ config, pkgs, ... }:
let

  vccvpn = pkgs.writeShellApplication {
    name = "vccvpn";
    runtimeInputs = [ config.programs.password-store.package ];
    text = ''
      CDSID='ejohnso3' 
      PASSWORD="$(pass volvo | head -n1)"
      POINTSHARP_PIN="$(pass pointsharp-pin | head -n1)"    
      read -rp 'OTP: ' POINTSHARP_TOKEN

      export CDSID PASSWORD POINTSHARP_PIN POINTSHARP_TOKEN
      /usr/local/bin/vccvpn "$@"
    '';
  };

in
{
  home.packages = [ vccvpn ];
}
  
