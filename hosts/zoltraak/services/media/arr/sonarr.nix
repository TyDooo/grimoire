{config, ...}: {
  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    dataDir = "/var/lib/sonarr";
  };

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
