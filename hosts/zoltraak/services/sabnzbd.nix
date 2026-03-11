{
  config,
  lib,
  ...
}: let
  inherit (lib) singleton;
  port = 8080;
in {
  services.sabnzbd = {
    enable = true;
    configFile = null;
    allowConfigWrite = true;
    # secretFiles = [config.sops.secrets."sabnzbd".path];
    # settings = {
    #   misc = {
    #     inherit port;
    #     complete_dir = "/mnt/user/downloads/usenet/complete";
    #     download_dir = "/mnt/user/downloads/usenet/incomplete";
    #     permissions = 770;
    #   };

    #   servers = {
    #     "eweka" = {
    #       name = "eweka";
    #       displayname = "eweka";
    #       host = "news.eweka.nl";
    #       port = 563;
    #       timeout = 60;
    #       connections = 50;
    #       ssl = true;
    #       ssl_verify = 3;
    #       enable = true;
    #       required = true;
    #       priority = 0;
    #     };
    #   };

    #   categories = {
    #     "*" = {
    #       priority = 0;
    #     };
    #     movies = {
    #       priority = -100;
    #       dir = "movies";
    #     };
    #     shows = {
    #       priority = -100;
    #       dir = "shows";
    #     };
    #     music = {
    #       priority = -100;
    #       dir = "music";
    #     };
    #     anime = {
    #       priority = -100;
    #       dir = "anime";
    #     };
    #     prowlarr = {
    #       priority = -100;
    #       dir = "prowlarr";
    #     };
    #   };
    # };
  };

  users.users.sabnzbd.extraGroups = ["media"];

  # Tunnel all traffic through Proton VPN
  systemd.services.sabnzbd = {
    after = ["proton0.service"];
    requires = ["proton0.service"];
    vpnConfinement = {
      enable = true;
      vpnNamespace = "proton0";
    };
    serviceConfig.UMask = "0002";
    # This shit doesn't work and I'm done with it -> disable
    preStart = lib.mkForce "";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/user/downloads/usenet                 0770 sabnzbd media - -"
    "d /mnt/user/downloads/usenet/complete        2770 sabnzbd media - -"
    "d /mnt/user/downloads/usenet/complete/movies 2770 sabnzbd media - -"
    "d /mnt/user/downloads/usenet/complete/shows  2770 sabnzbd media - -"
    "d /mnt/user/downloads/usenet/complete/music  2770 sabnzbd media - -"
    "d /mnt/user/downloads/usenet/complete/anime  2770 sabnzbd media - -"
    "d /mnt/user/downloads/usenet/incomplete      2750 sabnzbd media - -"
  ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/sabnzbd";
        inherit (config.services.sabnzbd) user group;
        mode = "0750";
      }
    ];
  };

  vpnNamespaces.proton0.portMappings = singleton {
    from = port;
    to = port;
  };

  sops.secrets."sabnzbd" = {
    owner = config.services.sabnzbd.user;
    inherit (config.services.sabnzbd) group;
    mode = "0600";
  };

  networking.firewall.allowedTCPPorts = [port];
}
