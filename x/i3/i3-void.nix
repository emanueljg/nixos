{ config, ... }:

{
  my.xsession.windowManager.i3.config = {
    workspaceOutputAssign = [
      { output = "DVI-D-1"; workspace = "4"; }
      { output = "DVI-D-1"; workspace = "5"; }
      { output = "DVI-D-1"; workspace = "6"; }

      { output = "DP-1"; workspace = "1"; }
      { output = "DP-1"; workspace = "2"; }
      { output = "DP-1"; workspace = "3"; }

      { output = "HDMI-1"; workspace = "7"; }
      { output = "HDMI-1"; workspace = "8"; }
      { output = "HDMI-1"; workspace = "9"; }
      { output = "HDMI-1"; workspace = "10"; }
    ];
  };
}

