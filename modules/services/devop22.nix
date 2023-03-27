{ config, pkgs, devop22, ... }:

{
  imports = [
    devop22.nixosModules.default
  ];

  # docs hosting
  documentation.nixos.extraModules = [ devop22.nixosModules.default ];
  documentation.nixos.options.warningsAreErrors = false;
  documentation.nixos.options.allowDocBook = false;

  system.autoUpgrade = {
    enable = true;
    flake = "github:emanueljg/nixos#loki";
    # run on the first and 30th second of every minute
    # -> run once every 30 seconds
    dates = "*-*-* *:*:00,30";
    flags = [ "--refresh" ] ++ (builtins.map 
      (i: "--update-input ${i}")
      [
        "app1-infrastruktur"
        "https-server-proxy"
        "nodehill-home-page"
        "devop22"
      ]
    );
  };

  services.devop22 = {
    enable = true;
    settingsPath = "/run/secrets/app1-infrastruktur-settings.json";

    served = let domain = ".boxedloki.xyz"; in [
      { 
        FQDN = "1" + domain; 
        app = "main";
        port = 4000;
      }
      { 
        FQDN = "2" + domain;
        app = "docs";
        port = 0;
      }
    ];

    stack1 = {
      enable = false;
    };
    stack2 = {
      enable = true;
    };
    stack3 = {
      enable = false;
    };
  };

  sops.secrets."app1-infrastruktur-settings.json" = {
    sopsFile = ../../secrets/app1-infrastruktur-settings.json;
    # it's, of course, not really a binary but a JSON-file. However,
    # anything that isn't a key-value file is considered binary. 
    # But then, why aren't we using the JSON-file as a key-value file?
    # 
    # Rationale: normal usage of sops for the JSON 
    # { "foo" = 1, "bar" = 2 },
    # would result in 
    # { "foo" = <secret hash for 2>, "bar" = <secret hash for 3> }.
    # Then, with the help of sops-nix, results in the files
    # > cat /run/secrets/foo
    # 1
    # > cat /run/secrets bar
    # 2
    # 
    # Our service requires an entire json file, the
    # { "foo" = 1, "bar" = 2 },
    # which doesn't work once deployed with keys scattered all over the place.
    # the solution is to encrypt as binary, which goes from normal json to
    # { "data" = <secret hash for '{ "foo" = 1, "bar" = 2 }'> }
    # then, once deployed with sops-nix, we have made the service happy with this:
    # > cat /run/secrets/foobar.json  # .json is just for clarity, no meaning in sops
    # { "foo" = 1, "bar" = 2 }
    #
    # this is of course suboptimal and goes against the elegant philosophy of sops(-nix),
    # but it does make everything work.
    format = "binary";  
    mode = "0440";
    owner = config.services.devop22.user;
    group = config.services.devop22.group;
  };

}
