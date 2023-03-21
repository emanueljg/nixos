{ config, lib, ... }: with lib; with types; let

  cfg = config.services.foo;

in rec {
  options.bar1 = mkOption {
        type = str;
        default = "baz";
  }; 

  options.bar2 = mkOption {
      type = str;
      default = "quox";
  };

  options.bar = mkOption {
    type = submoduleWith {
      shorthandOnlyDefinesConfig = false;
      modules = [
        ({ options = { baz = options.bar1; }; })
        ({ options = { quox = options.bar2; }; })
      ];
    };
    default = { };
  };

  config = {
   # bar = {
   #   baz = "baz";
   #   quox = "quox";
   # };
  };
}


