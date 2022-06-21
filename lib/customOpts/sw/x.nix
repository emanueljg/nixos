{ config, lib, ... }:

with lib; let
  cfg = config.customOpts.x;
in {


  options = {
    enable = mkEnableOption "X";
    
    customStartingTweaks = mkOption {
      description = ''
        NOTE: This option, amongst other things, disables the need to login. Only use this for a 
              very low-risk environment, quick and easy X debugging, or when using other types of safeguards.
              This is all in all horrible for opsec but it makes things just work, so whatever.
              This will be more intelligently set in the future - I think.

        Does several things to make the start of X more hassle-free.

        1. Autologins as "ejg"
        2. Sets a fake dummy session and instead let HM manage all of X
        3. Disables lightdm
      '';
      type = types.bool;
      default = false;
    };

  };

  config = mkIf cfg.enable {
    
