{config, ...}: {
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  users.users.plex.extraGroups = ["media"];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.plex.dataDir;
        inherit (config.services.plex) user group;
        mode = "0700";
      }
    ];
  };
}
