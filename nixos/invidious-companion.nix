{
  stdenv,
  fetchFromGitHub,
  denoPlatform,
  tree,
  pkgs,
  deno,
  writeShellApplication,
}:
let
  src = fetchFromGitHub {
    owner = "emanueljg";
    repo = "invidious-companion";
    rev = "master";
    hash = "sha256-C72yn5LJhKCJtaE0BDTQcHGwll94VsSL4oQelWqULa0=";
  };

  vendor = stdenv.mkDerivation {
    name = "invidious-companion-vendor";

    nativeBuildInputs = [
      deno
      tree
    ];

    inherit src;
    buildCommand = ''
      # Deno wants to create cache directories.
      # By default $HOME points to /homeless-shelter, which isn't writable.
      HOME="$(mktemp -d)"

      # Build vendor directory
      deno --version

      mkdir $out
      cd $out
      install -Dm664 ${src}/deno.lock .
      deno install --lock ./deno.lock --vendor
      ls -al $out
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-lYSaCIDRR6cHK4GH11wKTjmPGi+WMPANUOPwPgX6G1g=";
  };

  script = writeShellApplication {
    name = "invidious-companion";
    runtimeInputs = [
      deno
    ];
    text = ''
      ln -s ${vendor}/{node_modules,vendor} .
      deno run \
        --allow-import=github.com:443,jsr.io:443,cdn.jsdelivr.net:443,esm.sh:443,deno.land:443 \
        --allow-net \
        --allow-env \
        --allow-sys=hostname \
        --allow-read \
        --allow-write=/var/tmp/youtubei.js \
        --watch \
        --no-remote \
        --vendor \
        ${src}/main.ts "$@"
      # deno task dev \
      #   --cwd ${src} \
      #   --import-map=${vendor}/import_map.json} \
      #   --no-remote \
      #   "$@"
    '';
  };

in
denoPlatform.mkDenoBinary {
  name = "example-executable";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "invidious-companion";
    rev = "master";
    hash = "sha256-DFlWNecTvbgu/BdAQcGMxYdVVhF4IkYL4TVDemVd0C8=";
  };

  permissions.allow.all = true;
}
# denoPlatform.mkDenoDerivation {
#  name = "invidious-companion-git";

#  buildPhase = ''
#    deno task compile
#  '';

#  nativeBuildInputs = [
#    tree
#  ];

#  installPhase = ''
#    mkdir -p $out/bin
#    tree
#    cp ./invidious-companion $out/bin

#  '';

#  # permissions.allow.all = true;

# }
