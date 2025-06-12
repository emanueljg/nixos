{ mkWindowsApp
, wineWowPackages
, lib
, fetchurl
, linkFarmFromDrvs
, runCommandNoCC
, symlinkJoin
, unar
, unzip
, jq
, dos2unix
, runCommand
, system

, hdiffpatch
, dlData
, voiceLangs ? [ "en-us" "ja-jp" ]
, srcFrom ? null
, doPatch ? srcFrom != null
}:
mkWindowsApp (lib.fix (self:
let
  dlDataAttrs =
    if
      builtins.isAttrs dlData then
      dlData
    else if builtins.isPath dlData then
      builtins.fromJSON (builtins.readFile dlData)
    else
      builtins.abort "unrecognized dlData type";

  gameJSON =
    (builtins.elemAt
      dlDataAttrs.data.game_packages 0
    ).main;
  pkgToSrc = pkg:
    fetchurl {
      inherit (pkg) url;
      hash = builtins.convertHash {
        hash = pkg.md5;
        hashAlgo = "md5";
        toHashFormat = "sri";
      };
      curlOptsList = [
        "--http1.1"
      ];
    };
  mkGameData = game_pkgs:
    let
      gameSrcs = map pkgToSrc game_pkgs;
    in
    runCommandNoCC "${self.pname}-gamedir"
      {
        # to my knowledge, unar is the best choice for multipart extraction
        nativeBuildInputs = [ unar ];
        src = linkFarmFromDrvs "${self.pname}-zipfiles" gameSrcs;
        dontUnpack = true;
        strictDeps = true;
      } ''
      unar $src/${(builtins.elemAt gameSrcs 0).name} -D -o $out
    '';
  mkAudioData = audio_pkgs: lib.pipe audio_pkgs [
    (map (pkg: lib.nameValuePair pkg.language pkg))
    builtins.listToAttrs
    (xs: (lib.optionals (lib.asserts.assertEachOneOf "voiceLangs" voiceLangs (builtins.attrNames xs)) xs))
    (lib.getAttrs voiceLangs)
    (builtins.mapAttrs (n: v:
      runCommandNoCC "${self.pname}-audio-${n}"
        {
          nativeBuildInputs = [ unzip ];
          src = pkgToSrc v;
          dontUnpack = true;
          strictDeps = true;
        } ''
        unzip $src -d $out
      ''
    ))
  ];

  patchSet = (
    lib.findFirst
      (x: x.version == srcFrom.version)
      (builtins.abort "illegal patch!")
      gameJSON.patches
  );

  gamePatch = mkGameData patchSet.game_pkgs;
  audioPatches = mkAudioData patchSet.audio_pkgs;

in
{
  wine =
    let
      pkgsGit = (import
        (builtins.fetchTarball {
          url = "https://github.com/nixos/nixpkgs/archive/b7a396f1af05274fcc760794569326f29b492367.tar.gz";
          sha256 = "sha256:1kxa8aibf1imsfran60b8yz9jrh52cd8ffky4rsl48dkgmqb3dr3";
        })
        {
          inherit system;
        }
      );
    in
    pkgsGit.wineWowPackages.stagingFull;


  # wineWowPackages.stagingFull;

  pname = "zenless-zone-zero";
  version = gameJSON.major.version + lib.optionalString doPatch "-p(${srcFrom.version})";

  strictDeps = true;

  src =
    let
      mainSrc = symlinkJoin {
        name = "${self.pname}-src";
        passthru = {
          inherit (self) version;
          gameData = mkGameData gameJSON.major.game_pkgs;
          audioData = mkAudioData gameJSON.major.audio_pkgs;
        };

        paths = [
          self.src.passthru.gameData
        ] ++ builtins.attrValues self.src.passthru.audioData;

      };
    in
    if (srcFrom == null) then
      mainSrc
    else
      runCommand "${self.pname}-src-patched"
        {
          src = mainSrc;
          nativeBuildInputs = [
            jq
            hdiffpatch
            dos2unix
          ];
          dontUnpack = true;
          strictDeps = true;
          __structuredAttrs = true;
          patchDirs = [ self.src.gamePatch ] ++ builtins.attrValues audioPatches;

        } ''
        mkdir $out

        findargs='-not -name *.hdiff -not -name deletefiles.txt -not -name hdifffiles.txt'

        for patchDir in ''${patchDirs[@]}; do
          # add ignores from deletefiles.txt
          if [ -e ''${patchDir}/deletefiles.txt ]; then
            while IFS= read -r line; do
              findargs="$findargs -not -path '*/'$line"
            done < "$(dos2unix ''${patchDir}/deletefiles.txt -O)"
          fi

          # patch all files
          if [ -e ''${patchDir}/hdifffiles.txt ]; then
            while IFS= read -r line; do
              patchpath="$(echo "$line" | jq -r '.remoteName')"
              hpatchz "$src/$patchpath" ''${patchDir}/''${patchpath}.hdiff "$out/patchpath"
            done < ''${patchDir}/hdifffiles.txt
          fi

          # copy over all remaining patch files
          pushd $patchDir
          find . -type f $findargs -exec cp --parents {} $out \;
          popd

        done

        # copy over all game files (--update=none ensures patch files aren't overwritten)
        pushd $src
        find . -type f $findargs -exec cp --parents --update=none {} $out \;
        popd
    
      '';

  # Hoyo streams ?.?.XXX... hotfixes outside of the HYP api while in the game.
  # This means we can't fetch it ourselves in drv src. 
  # Therefore, we persist the runtime layer so we don't force the run layer 
  # to re-fetch data every time the app starts up. 
  persistRuntimeLayer = true;

  enableMonoBootPrompt = false;
  dontUnpack = true;
  wineArch = "win64";
  enableVulkan = true;
  graphicsDriver = "wayland";
  enableInstallNotification = false;

  winAppInstall = ''
    d="$WINEPREFIX/drive_c/${self.pname}"
    cp -rLT --no-preserve=mode ${self.src} "$d"

    cp -L --no-preserve=mode ${./config.ini} $d
    winetricks dxvk
    winetricks vcrun2022
  '';

  winAppRun = ''
    wine "$WINEPREFIX/drive_c/${self.pname}/ZenlessZoneZero.exe"
  '';

  installPhase = ''
    runHook preInstall
    ln -s $out/bin/.launcher $out/bin/${self.pname}
    runHook postInstall
  '';

}))
