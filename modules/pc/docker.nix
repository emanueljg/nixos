{pkgs, ...}: {
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = ["ejg"];
  users.users.ejg.extraGroups = ["docker"];
  environment.systemPackages = with pkgs; [docker-compose];
}
