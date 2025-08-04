{ _cfg
, _config

, lib
, symlinkJoin
, writeTextDir
, makeWrapper

, enableXWayland ? false
}:
let
  cfg = _cfg;
  config = _config;
in
symlinkJoin {
  name = "hyprland-confed";
  paths = [
    (cfg.package.override { inherit enableXWayland; })
  ];
  nativeBuildInputs = [
    makeWrapper
  ];
  inherit (cfg.package) version;
  postBuild = ''
    wrapProgram $out/bin/Hyprland \
      --add-flags '--config ${
        let
          pluginsToHyprconf =
            plugins:
            config.local.lib.toHyprConf {
              attrs = {
                "exec-once" =
                  let
                    mkEntry =
                      entry: if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else entry;
                  in
                  map (p: "hyprctl plugin load ${mkEntry p}") cfg.plugins;
              };
              inherit (cfg) importantPrefixes;
            };
        in 
        lib.optionalString (cfg.plugins != [ ]) (pluginsToHyprconf cfg.plugins)
        + lib.optionalString (cfg.settings != { }) (
          config.local.lib.toHyprConf {
            attrs = cfg.settings;
            inherit (cfg) importantPrefixes;
          }
        )
        + lib.optionalString (cfg.extraConfig != "") cfg.extraConfig
      }/hypr/hyprland.conf'
  '';
}

