{ ... }:

{
  programs.ssh.extraConfig = let
    user = "User ejg";
    id = "IdentityFile /home/ejg/.ssh/id_rsa_mothership";
    boiler = ''
      ${user}
      ${id}
    '';
  in ''
    Host crown
      HostName 192.168.0.2
      ${boiler}
      
    Host seneca
      HostName 192.168.0.4
      ${boiler}
  '';
}
