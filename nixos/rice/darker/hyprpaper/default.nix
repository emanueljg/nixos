{ pkgs, lib, doesnotexist, ... }:
let
  papes = {
    # tank-top = pkgs.fetchurl {
    #   url = "https://w.wallhaven.cc/full/qd/wallhaven-qde6kq.png";
    #   hash = "sha256-RXrsHOrzEQCUAKS9/X7nFv0S8FbZFQzP35JGHajDqUs=";
    # };
    # white-dress = pkgs.fetchurl {
    #   url = "https://w.wallhaven.cc/full/9m/wallhaven-9m37g8.png";
    #   hash = "sha256-uW5r4qVbxqQZB1/oEiZOgRO/9bhs5wYFI0khLX9GsZY=";
    # };
    # jeans-shorts =
    #   lib.fix (self: (pkgs.runCommand "wallhaven-w81j1x-im.jpg"
    #     {
    #       src = pkgs.fetchurl {
    #         url = "https://w.wallhaven.cc/full/w8/wallhaven-w81j1x.jpg";
    #         hash = "sha256-DktvX/rZEbJnjqCywTfyXMIsF1oEEISssAF17xi6Edc=";
    #       };
    #       nativeBuildInputs = [ pkgs.imagemagick ];
    #     } ''
    #     magick ${self.src} \
    #       -crop +100+0 +repage \
    #       -crop -290+0 +repage \
    #       -scale 1080x1920! $out
    #   ''));
    # ol3 =
    #   lib.fix (self: (pkgs.runCommand "wallhaven-nr5vgw-im.jpg"
    #     {
    #       src = pkgs.fetchurl {
    #         url = "https://w.wallhaven.cc/full/nr/wallhaven-nr5vgw.jpg";
    #         hash = "sha256-3gu+rZ/xFh/+aAwVmBPn3NpeY9s9cs8k5MtNJMjt9Sk=";
    #       };
    #       nativeBuildInputs = [ pkgs.imagemagick ];
    #     } ''
    #     magick ${self.src} \
    #       -crop +100+0 +repage \
    #       -crop -100+0 +repage \
    #       -scale 1080x1920! $out
    #   ''));
    # ganyu =
    #   lib.fix (self: (pkgs.runCommand "wallhaven-m96xkm-im.jpg"
    #     {
    #       src = pkgs.fetchurl {
    #         url = "https://w.wallhaven.cc/full/m9/wallhaven-m96xkm.jpg";
    #         hash = "sha256-gfPhkrhYacXoeOmPdCQA76gJibOOxi1RH53+T9/FzdA=";
    #       };
    #       nativeBuildInputs = [ pkgs.imagemagick ];
    #     } ''
    #     magick ${self.src} \
    #       -crop 1080x1920+30%+0 \
    #       $out
    #   ''));
    everlasting-summer-electronics = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/4l/wallhaven-4lk382.jpg";
      hash = "sha256-sZuZAm1e6HipJmYx73Xt44nbt+7frz9LesFshL376l0=";
    };
    konosuba-megumin-field = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/7j/wallhaven-7j3v1o.jpg";
      hash = "sha256-sLOdvKnI0S4L+7bTHWRG2VZLZptYB2AT7aLcVevwTUk=";
    };
    slime-wind-chimes = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/gw/wallhaven-gwjvjd.png";
      hash = "sha256-8PAqI75vZwDH7W56rxkmHArWcDg1dOYo6u3tEBCH8Ec=";
    };
    bleach-frisbee = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/mp/wallhaven-mp5r3m.jpg";
      hash = "sha256-vAuE2o/Ej34ZY3VFzDTVqyYqFevWjTxyOqesC9pV0+M=";
    };
    porco-rosso-nap = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/9d/wallhaven-9dokjx.jpg";
      hash = "sha256-+LgzR7LPl7wpO3u+v9mMhosiVwRwrXzsujLqsXFTnNY=";
    };
  };
in
{

  local.services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = lib.pipe papes [
        builtins.attrValues
        (map (builtins.toString))
      ];
      wallpaper = [
        # "HDMI-A-1,${papes.ganyu}"
        "DP-2,${papes.everlasting-summer-electronics}"
        "DP-1,${papes.konosuba-megumin-field}"
        "eDP-1,${papes.porco-rosso-nap}"
      ];
    };
  };
}
