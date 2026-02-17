{config, ...}: let
  mediaPath = "/mnt/user/media";
in {
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/radarr";
  };

  # Add the Radarr user to the shared group to allow access to the library
  users.users.radarr.extraGroups = ["shared"];

  # Ensure that the dataDir exists with the correct permissions.
  # Needed because a custom location is used, resulting in the
  # directory not being created automatically.
  systemd.tmpfiles.settings."10-radarr" = {
    "${config.services.radarr.dataDir}".d = {
      mode = "0700";
      inherit (config.services.radarr) user group;
    };
  };

  systemd.services.radarr = {
    # Ensure that the SMB share is mounted
    unitConfig.RequiresMountsFor = mediaPath;
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.radarr.dataDir;
        inherit (config.services.radarr) user group;
        mode = "0700";
      }
    ];
  };
}
