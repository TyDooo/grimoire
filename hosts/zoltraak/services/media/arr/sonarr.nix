{config, ...}: {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/sonarr";
  };

  # Add the Sonarr user to the media group to allow access to the library
  users.users.sonarr.extraGroups = ["media"];

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
