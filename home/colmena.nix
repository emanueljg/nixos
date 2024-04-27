{ pkgs, ... }: {
  home.shellAliases =
    let
      origin = "github:emanueljg/nixos";
    in
    {
      "col" = "colmena --config=${origin}";
      "cola" = "col apply";
      "coll" = "col apply-local --sudo";
    };

  home.packages = with pkgs; [
    colmena
  ];

  home.sessionVariables."SSH_CONFIG_FILE" = pkgs.writeText "colmena-ssh-config" ''
    Host *
      IdentityFile ~/.ssh/id_rsa_mothership
  '';
  # (colmena.overrideAttrs (oldAttrs: rec {
  #   version = "0.4.0pre";
  #   src = fetchFromGitHub {
  #     owner = "zhaofengli";
  #     repo = "colmena";
  #     rev = "main";
  #     sha256 = "sha256-XcmirehPIcZGS7PzkS3WvAYQ9GBlBvCxYToIOIV2PVE=";
  #   };
  #   cargoDeps = oldAttrs.cargoDeps.overrideAttrs(_: {
  #     inherit src;
  #     outputHash = "sha256-U9vxDogjESNRrDqDGC27qfRyGLkmDWQ1gNxqAehUfwk=";
  #   });
  # }))
  # ];
}
