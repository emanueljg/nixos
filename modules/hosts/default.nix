rec {
  "void" = {
    ip = "192.168.0.3";
    modules = [ ./void ];
  };

  "seneca" = {
    ip = "192.168.0.4";
    modules = [ ./seneca ];
  };

  "_oakleaf" = {
    ip = "127.0.0.1";
    modules = [ ./oakleaf ];
  };

  "oakleaf-home" = _oakleaf // {
    modules = [ ./oakleaf/spec-home.nix ];
  };

  "oakleaf-laptop" = _oakleaf;

  "weasel" = {
    ip = "127.0.0.1";
    modules = [ ./weasel ];
  };
  "stoneheart" = {
    ip = "127.0.0.1";
    modules = [ ./stoneheart ];
  };
}

