{ stdenv
, lib
, love
, lovely-injector
, fetchtorrent
, p7zip
, copyDesktopItems
, makeWrapper
, makeDesktopItem
, withMods ? true
, withLinuxPatch ? true
,
}:
let
  version = "b17459173";
  balatroExe = "${fetchtorrent {
    url = "magnet:?xt=urn:btih:8E417A3B637A10DF421BDF36EE1E33928142C7D8&tr=http%3A%2F%2Fbt4.t-ru.org%2Fann%3Fmagnet&dn=%5BDL%5D%20Balatro%20%5BP%5D%20%5BRUS%20%2B%20ENG%20%2B%2011%5D%20(2024%2C%20TBS)%20(Build%2017459173%20%2B%201%20DLC)%20%5BPortable%5D";
    hash = "sha256-pY881o945ZL1COjrO1JV2AwnbSG7S1i9V2o7nbdNQyo=";
  }}/Balatro.exe";

in
stdenv.mkDerivation {
  pname = "balatro";
  inherit version;
  nativeBuildInputs = [
    p7zip
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = [ love ] ++ lib.optional withMods lovely-injector;
  dontUnpack = true;
  desktopItems = [
    (makeDesktopItem {
      name = "balatro";
      desktopName = "Balatro";
      exec = "balatro";
      keywords = [ "Game" ];
      categories = [ "Game" ];
      icon = "balatro";
    })
  ];
  buildPhase = ''
    runHook preBuild
    tmpdir=$(mktemp -d)
    7z x ${balatroExe} -o$tmpdir -y
    ${if withLinuxPatch then "patch $tmpdir/globals.lua -i ${./globals.patch}" else ""}
    patchedExe=$(mktemp -u).zip
    7z a $patchedExe $tmpdir/*
    runHook postBuild
  '';

  # The `cat` bit is a hack suggested by whitelje (https://github.com/ethangreen-dev/lovely-injector/pull/66#issuecomment-2319615509)
  # to make it so that lovely will pick up Balatro as the game name. The `LD_PRELOAD` bit is used to load lovely and it is the
  # 'official' way of doing it.
  installPhase = ''
    runHook preInstall
    install -Dm444 $tmpdir/resources/textures/2x/balatro.png -t $out/share/icons/

    cat ${lib.getExe love} $patchedExe > $out/share/Balatro
    chmod +x $out/share/Balatro

    makeWrapper $out/share/Balatro $out/bin/balatro ${lib.optionalString withMods "--prefix LD_PRELOAD : '${lovely-injector}/lib/liblovely.so'"}
    runHook postInstall
  '';

  meta = {
    description = "Poker roguelike";
    longDescription = ''
      Balatro is a hypnotically satisfying deckbuilder where you play illegal poker hands,
      discover game-changing jokers, and trigger adrenaline-pumping, outrageous combos.
    '';
    # license = lib.licenses.unfree;
    homepage = "https://store.steampowered.com/app/2379780/Balatro/";
    maintainers = [ lib.maintainers.antipatico ];
    platforms = love.meta.platforms;
    mainProgram = "balatro";
  };
}
