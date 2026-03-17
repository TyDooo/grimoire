{config, ...}: {
  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    dataDir = "/var/lib/sonarr";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/user/media/shows 2775 root media - -"
  ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.sonarr.dataDir;
        inherit (config.services.sonarr) user group;
        mode = "0750";
      }
    ];
  };
}
