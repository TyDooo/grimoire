{config, ...}: {
  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    dataDir = "/var/lib/radarr";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/user/media/movies 2775 root media - -"
  ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.radarr.dataDir;
        inherit (config.services.radarr) user group;
        mode = "0750";
      }
    ];
  };
}
