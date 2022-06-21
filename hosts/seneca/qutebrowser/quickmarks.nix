{
  imports = [
    ../../hm.nix
  ];
  my.programs.qutebrowser.quickmarks = {
    f-d = "https://discord.com/channels/@me";

    y-hn = "https://www.youtube.com/watch?v=HUd_ikEGPPM&list=PLmJS4rAJemEaN6k5S0g43vDlSib1qWudz"; 

    t-no-opt = "https://search.nixos.org/options";
    t-no-hm = "https://nix-community.github.io/home-manager/options.html";
    t-no-pkgs = "https://search.nixos.org/packages";
    t-no-lang = "https://teu5us.github.io/nix-lib.html#nix-builtin-functions";

    t-qb-faq = "https://qutebrowser.org/FAQ.html";
    t-qb-func = "https://qutebrowser.org/doc/help/commands.html";
    t-qb-us = "https://qutebrowser.org/doc/userscripts.html";

    t-dl-nsi = "https://nyaa.si/";
    t-dl-rbg  = "https://rarbg.to/torrents.php";
    t-dl-1337x = "https://www.1377x.to/";

    s-dl = "192.168.1.2:34012";
    s-jf = "192.168.1.2:8096";
  };
}
