# WARN:
#   The `intel-media-sdk` is deprecated and does not build on recent channels.
#   Use VAAPI instead of QSV for hardware transcoding.
{config, ...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = ["media"];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.jellyfin.dataDir;
        inherit (config.services.jellyfin) user group;
        mode = "0700";
      }
    ];
  };
}
