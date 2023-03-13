{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (st.overrideAttrs (oldAttrs: rec {
      # Using a local file
      configFile = writeText "config.def.h" (builtins.readFile ./config.def.h);
      # Or one pulled from GitHub
      # configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner = "LukeSmithxyz"; repo = "st"; rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b"; sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag"; }}/config.h");
      postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
    }))
  ];
}
