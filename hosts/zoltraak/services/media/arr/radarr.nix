{config, ...}: {
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/radarr";
  };

  users.users.radarr.extraGroups = ["media"];

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
