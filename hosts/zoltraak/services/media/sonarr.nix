{config, ...}: let
  mediaPath = "/mnt/user/media";
in {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/sonarr";
  };

  # Add the Sonarr user to the shared group to allow access to the library
  users.users.sonarr.extraGroups = ["shared"];

  # Ensure that the dataDir exists with the correct permissions.
  # Needed because a custom location is used, resulting in the
  # directory not being created automatically.
  systemd.tmpfiles.settings."10-sonarr" = {
    "${config.services.sonarr.dataDir}".d = {
      mode = "0700";
      inherit (config.services.sonarr) user group;
    };
  };

  systemd.services.sonarr = {
    # Ensure that the SMB share is mounted
    unitConfig.RequiresMountsFor = mediaPath;
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.sonarr.dataDir;
        inherit (config.services.sonarr) user group;
        mode = "0700";
      }
    ];
  };
}
